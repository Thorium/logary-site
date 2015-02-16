# ZipKin - Logary Target

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
Install-Package Logary.Targets.Zipkin
```

![Zipkin](https://raw.githubusercontent.com/logary/logary-assets/master/targets/zipkin.png)

