# EventStore adapter

The [EventStore](http://geteventstore.com/) adapter is really easy to use; just
call [LogManager.SetLogFactory][es-code] with it.

First `Install-Package Intelliplan.Logary.Adapters.EventStore` from nuget to get
the package.

Usage:

``` fsharp
open EventStore.ClientAPI
open EventStore.ClientAPI.Common.Log

use logary =  ...

LogManager.SetLogFactory(fun name -> LogaryAdapter(logary.GetLogger name))
```

Also see [configuring
logging](docs.geteventstore.com/dotnet-api/3.0.1/configuring-logging).


 [es-code]: https://github.com/EventStore/EventStore/blob/dev/src/EventStore.Common/Log/LogManager.cs#L80
