# Graphite - Logary Target

**For Measures | builtin**

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

``` powershell
Install-Package Logary
```

![Grafana](https://raw.githubusercontent.com/logary/logary-assets/master/targets/grafana.png)
