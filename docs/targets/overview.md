# Targets Overview


#### Target: Logary.TextWriter *builtin*

**For LogLines**

Write to any text writer - such as one from `System.IO.File.OpenWrite`.

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

#### Target: Logary.Console *builtin*

**For LogLines**

Writes output messages to `System.Console.Out` and Error, and Fatal LogLines
to `System.Console.Error`.

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

#### Target: Logary.Debugger *builtin*

**For LogLines**

Writes all output to the Debugger-console of Visual Studio, Xamarin Studio or
MonoDevelop.

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

#### Target: Logary.Logstash *builtin*

**For LogLines**

This is the most mature target that we use the most at Intelliplan. Logstash is
a log router that can move your logs to the best location available.

> **Manage events and logs**. Elasticsearch works seamlessly with Logstash to
> collect, parse, index, and search logs

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

![Logstash](https://raw.githubusercontent.com/logary/logary-assets/master/targets/logstash.png)

#### Target: Logary.Graphite *builtin*

**For Measures**

The [graphite](http://graphite.wikidot.com/faq) target is a mature target for
sending Measures from your application.

> **Graphite - Scalable Realtime Graphing.**  Graphite is a highly scalable
> real-time graphing system. As a user, you write an application that collects
> numeric time-series data that you are interested in graphing, and send it to
> Graphite's processing backend, carbon, which stores the data in Graphite's
> specialized database. The data can then be visualized through graphite's web
> interfaces.

Best used in conjunction with [Grafana](http://grafana.org/) (a web front-end):

> An open source, feature rich metrics dashboard and graph editor for Graphite,
> InfluxDB & OpenTSDB. Rich graphing: Fast and flexible client side graphs with
> a multitude of options.

![Grafana](https://raw.githubusercontent.com/logary/logary-assets/master/targets/grafana.png)

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

#### Target: Logary.ElmahIO

**For LogLines**

Interop target if you are writing a web application and have
[Elmah.IO](https://elmah.io/) as your log dashboard. <span title="Unless you're
scared of the big, big world out there, consider using something that many other
sorts of developers than .Net developers use, such as one of the other
targets">.Net developer friendly indeed</span>.

``` powershell
Install-Package Intelliplan.Logary.ElmahIO -Pre
```

![Elmah.IO](https://raw.githubusercontent.com/logary/logary-assets/master/targets/elmahio.png)

#### Target: Logary.Logentries

**For LogLines and Measures**

> Fast Search & Real-time Log Processing - Centralized search, aggregation, and
> correlation. See query results in seconds.

``` powershell
Install-Package Intelliplan.Logary.Logentries -Pre
```

All logging to Logentries is encrypted.

![Logentries](https://raw.githubusercontent.com/logary/logary-assets/master/targets/logentries.png)

#### Target: Logary.Loggr

**For LogLines**

> **Monitor Your Web Apps in Realtime**
> Get a control panel for your web app with event logging, user monitoring,
> analytics, notifications and more

``` powershell
Install-Package Intelliplan.Logary.Loggr -Pre
```

![Loggr](https://raw.githubusercontent.com/logary/logary-assets/master/targets/loggr.png)

#### Target: Logary.Riemann

**For Measures**

This target writes Measures to Riemann and is being used for sending metrics
from SQLServerHealth, for example. Sending them to riemann gives a platform to
start acting on what goes on in your system and can be a way to provide
auto-scaling to your deployments based off of application metrics.

Riemann is built in Clojure, and so is its config, so it gives you an
opportunity to try something new and learn a nice language.

> **Riemann monitors distributed systems.** Riemann aggregates events from your
> servers and applications with a powerful stream processing language.

``` powershell
Install-Package Intelliplan.Logary.Riemann -Pre
```

![Riemann](https://raw.githubusercontent.com/logary/logary-assets/master/targets/riemann.png)

As a matter of fact, I have implemented a brand [new .Net
client](https://github.com/logary/logary/blob/feature/protobuf-riemann/src/Logary.Riemann/Client.fs#L56)
for Riemann, to make it stable and to make it fit well with Logary's
actor-based approach. More usage examples on this will follow.

#### Target: Logary.DB

**For LogLines and Measures**

This target logs asynchronously to a database, using ADO.Net. You can configure
any connection factory through the target's configuration.

The target also comes with **Logary.DB.Migrations** that set up the database
state for both logs and metrics on boot, if not already existent.

``` powershell
Install-Package Intelliplan.Logary.DB -Pre
Install-Package Intelliplan.Logary.DB.Migrations -Pre
```

#### Target: Logary.Nimrod *builtin*

**For LogLines and Measures**

Nimrod is a metrics server based on log processing - as such it can handle both
LogLines and Measures.

> Nimrod is a metrics server purely based on log processing: hence, it doesn't
> affect the way you write your applications, nor has it any side effect on them.

**Part of the core assembly:**

``` powershell
Install-Package Intelliplan.Logary -Pre
```

![Nimrod](https://raw.githubusercontent.com/logary/logary-assets/master/targets/nimrod.png)

#### Target: Logary.Dash

Work in progress - aims to provide the same dashboard as Metrics.Net, allowing
you runtime insight into your programs.

``` powershell
Install-Package Intelliplan.Logary.Dash -Pre
```

The dashboard uses the awesome F# web server [suave.io](http://suave.io/).

#### Target: Logary.Zipkin

**For LogLines - and adds Spans**

Currently work in progress: LogLines and Measures become annotations to Spans
which are correlated in process and then sent through Thrift to the Zipkin
server as Spans/traces.

> Zipkin is a distributed tracing system that helps us gather timing data for
> all the disparate services at Twitter. It manages both the collection and
> lookup of this data through a Collector and a Query service. We closely
> modelled Zipkin after the Google Dapper paper. Follow @ZipkinProject for
> updates.

``` powershell
Install-Package Intelliplan.Logary.Zipkin -Pre
```

![Zipkin](https://raw.githubusercontent.com/logary/logary-assets/master/targets/zipkin.png)
