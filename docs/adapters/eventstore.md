# EventStore adapter

The [EventStore](http://geteventstore.com/) adapter is really easy to use; just
call [LogManager.SetLogFactory][es-code] with it.

First:

```
Install-Package Logary.Adapters.EventStore
Install-Package EventStore.Client.FSharp
```

to get the nicities for F#.

Usage:

``` fsharp
open EventStore.ClientAPI
open EventStore.ClientAPI.Common.Log

use logary =  ...

let conn =
  ConnectionSettings.configureStart()
  |> ConnectionSettings.useCustomLogger (LogaryLogger(logary.GetLogger("EventStore")))
  |> ConnectionSettings.configureEnd (IPEndPoint(IPAddress.Loopback, 1113))
```

Also see [configuring
logging](docs.geteventstore.com/dotnet-api/3.0.1/configuring-logging).


 [es-code]: https://github.com/EventStore/EventStore/blob/dev/src/EventStore.Common/Log/LogManager.cs#L80
