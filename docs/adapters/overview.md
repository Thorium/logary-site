# Logary Adapters

Adapters are plug-ins into OTHER libraries, which can then output their internal
logs into logary, which in turn takes care of sending those logs further.

## Suave

Usage:

``` fsharp
let web_config =
  { default_config with
      bindings = context.settings.GetBindings ()
      logger   = SuaveAdapter(logary.GetLogger "suave")
  }
```

## Topshelf

Usage

TBD

## EventStore

Usage:

``` fsharp
open EventStore.ClientAPI
open EventStore.ClientAPI.Common.Log

use logary =  ...

LogManager.SetLoggerFactory(fun name -> LogaryAdapter(logary.GetLogger name))
```

Also see [configuring
logging](docs.geteventstore.com/dotnet-api/3.0.1/configuring-logging).

## CommonLogging

Please help fill out!

## log4net

Please help fill out!


