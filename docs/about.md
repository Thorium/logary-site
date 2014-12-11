# More on Logary

The first observation is that almost all metrics stem from individual events
which have a path, value and unit. The path is what they are named and where the
event occurred. The value is often 'one', meaning that it's a singular event that
occurred. Sometimes, more than one unit is the value, e.g. when a user 'ordered
two books' - a single event but with a non-zero value. The unit can be things
like 'a unit of something' such as a 'request' or a 'click', or it can be a
duration like 'it took 2ms to call the db and get a response' -- however, it can
also be observed that a duration is really two individual events of a unit
value; 'created connection to db' and 'closed connection to db after reading',
both of which are instantaneous first-order events.

Secondary-order events are therefore things that something else has analysed,
such as the 'mean duration of sql statement execution' as read from a
'resource', such as a service's database. It's a measure of interest to the
service that you are writing, as you depend on the database's performance to
make your service work. However, you don't have the first-order instant-events
that go into creating the second-order event that you observe, because those two
events are not being broadcast back to your service (sql statement execution
started, sql statement execution ended) and possibly doing that would cause too
much data to be sent. We'll get back to second-order events soon, but keep in
mind that they are already processed first-order events that most often don't
originate from our own service.

An event is either a Measure or a LogLine. A Metric is a single or many
processed measures, but a metric is also an event when the value of the metric
is one.

Your service depends on other services to work; they are 'attached resources'
(12factor app). You have both required resources and optional resources.
Required resources you need to have your service running, but optional resources
you can live without by providing 'dumbed down' data as output to queries and
requests.

You can yourself be an attached resource of other (upstream) services, or in
other words you can build 'servers' that service 'clients'.

When you make a request a resource from your service you often expect to get a
response back, or at the very least, an ACK that your request was successfully
received and parsed. The logging of such interactions between services is called
distributed tracing.

When you start sending a request you can produce an event with a corresponding
tag, and when you receive the response in full (or in part if it's a streaming
response) you produce another event. It's up to Logary to coalesce these two
events into a Span (see Dapper/ZipKin) and generate the expected request/span
id.

By tracking these two events as a Span, we can get an idea about what
CodaHaleMetrics talks about as a 'Timer'. In CodeHaleMetrics' vocabulary it is
the 'rate that a particular piece of code is called and the distribution of its
duration'. In order to understand what that means, we have to introduce two more
concepts besides the Span and events that we have already discussed.

The Meter is a derived statistic from more than one Measure/event; the rate of
events over time, e.g. 'requests per second'. In Logary we have two options for
dealing with Meters: either ship the raw Measures as data to Riemann or Graphite
and let those single-purpose services/resources deal with the roll-up
calculation (monoidal in nature!), or alternatively do the calculation in
process based off of a Reservoir, like CodaHaleMetrics does it. However, we
don't want to expose any 'object' or 'interface' that is a 'Meter' because it's
not a value that is given from user code (i.e. the code that you, dear reader,
write as a part of using Logary). Instead, you can register actors in the
Registry that calculate the Meter function that gives you averages and
time-decaying moving averages.

The second concept we need to look at to understand Spans and how they can be
used to track rates (Meters) and distributations; is Histograms. A histogram is
also a calculated value that measures the statistical distribution of values in
a stream of data. A Histogram function places values it observes into buckets
while allocating those buckets on the fly; or in other words, it allows you to
see the distribution of Measures in a frequency diagram.

So to get back to the Span abstraction; with the two input events, with their
corresponding Instants (discrete points on the time line as seen by the
computing node or CPU), lets us use the Meter and Histogram function to get more
insight into our code as it is executing.

On top of allowing this insight based on only their underlying events, the
tagging that must happen in client-server software allows Logary to figure our
enough to attach LogLines/Annotations to the span, as well as to create a
SpanTree that gives insight into points of possible parallelism and contention
in a distributed system. (again, see the Dapper paper and ZipKin from Twitter).

As you read in the previous paragraph, spans can have attached annotations; that
in logary are simple LogLines. A log line is a way to move meta-data about a
context to a location where a programmer can inspect that meta-data to
understand how his/her program is behaving in production. It's also simply
called logging. However, what Logary gives you is a the conjunction of the above
concepts in a single library. It allows you to use only a few concepts from your
own code, but extract a wealth of data.

### Targets

When building a modern distributes system you need to move the data off the
computing nodes, or you will surely suffer the wrath of bad data locality,
filled up disks and angry operations people. Not to mention problems of data
correlation and obtruse RDP/SSH-ing into production nodes, which all-in-all is well
worth avoiding. Logary is here to help, and it has implemented a whole range of
targets to do exactly that.

The idea is that you should always be using the best tool for the job. For
logging you should be using Logstash - send Logstash your logs and forget about
them on the computing node.

For metrics you should be using Graphite - it allows you to use statistical
functions on your data points, allows you to degrade the granularity of your
data points over time to save space while still getting the jest of the
long-term trends and finally allows you to browse the data/metrics in a nice GUI
(even nicer if you put Grafana on top!).

For decisions and health of your services you should be using Riemann; it's a
great Complex Event Processing (CEP) engine which allows you to do the similar
statistical calculations on your data as Graphite does, except that it also can
trigger events and send messages based on those calculations. That means that
you don't have to write custom code to read and understand the Graphite graphs,
but can implement that in sweet-Jesus-clojure on the Riemann side.

For example, if you have a continuous deployment pipeline set up, you may want
to send events to Riemann any time you have an exception, let Riemann calculate
the exception rate as a baseline and then compare that baseline to the exception
rate of a newly deployed version; rolling the deploy back if the exception rate
goes outside of, say, two standard deviations of the baseline.

That's three targets and counting. To help those of you who still want log
output on your dev machine (who doesn't?), there are also TextWriter targets for
e.g. the console and debugger, so you can use Logary for development.

Targets can react on the two things they are sent; either LogLines or Measures.
How a targets acts it up to it, and there are Rules that decide whether a target
should be sent a given LogLine or Measure, and those Rules are given to the
configuration API at service startup, when you start Logary. Those rules are the
only performance-optimisation that Logary does (but boy, is that a great
optimisation!).

Targets are implemented as asynchronous F# actors and they are registered in the
Registry and watched over by the Supervisor actor that is spawed when Logary is
spawned. They have a OneByOne supervision policy attached to themselves, so that
e.g. a TCP socket exception will trigger an actor restart.

In general, the idea is that targets should be super-simple to implement; a full
implementation takes a senior developer about half an hour to write and comes
ready with a config API and the above supervision, out of the box. More time can
then be spent to test it or implement optimisations such as exception handling
(actors are otherwise following the dogma; 'let it crash', so you don't
necessarily have to handle exceptions). Time is also then spent on furthering
the test suite coverage and writing a nice fluent API for C# (aka. FactoryApi).

