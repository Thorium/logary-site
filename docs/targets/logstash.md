# Logstash - Logary Target

**For LogLines | builtin**

Logstash is
a log router that can move your logs to the best location available.

> **Manage events and logs**. Elasticsearch works seamlessly with Logstash to
> collect, parse, index, and search logs

``` powershell
Install-Package Logary
```

![Logstash](https://raw.githubusercontent.com/logary/logary-assets/master/targets/logstash.png)

This target sends logs to logstash using a TCP socket, meaning there's not that
much to set up to get started. This means that once in a blue moon you'll
lose log lines - but often this is not a big issue, because you don't take
application business logic decisions on log lines.

## API

``` fsharp
open System

open Logary
open Logary.Configuration
open Logary.Targets

[<EntryPoint>]
let main argv =
  use logary =
    withLogary' "Riemann.Example" (
      withTargets [
        Logstash.create (Logstash.LogstashConf.Create("logstash.prod.corp.tld",
1939us)) "logstash"
      ] >>
      withRules [
        Rule.createForTarget "logstash"
      ]
    )

  Console.ReadKey true |> ignore
  0

```

## Logstash config

Logstash can only take 'json' codec from things that do proper framing, such as
message brokers.

```
input {
  tcp {
    codec => json_lines { charset => "UTF-8" }
    host  => "0.0.0.0"
    port  => 1939
    type  => "apps"
  }
}
```
