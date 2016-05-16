# API

This package works great with F#:

``` fsharp
open System

open NodaTime

open Logary
open Logary.Configuration
open Logary.Targets
open Logary.Metrics

[<EntryPoint>]
let main argv =
  use logary =
    withLogaryManager "Riemann.Example" (
      withTargets [
        Riemann.create (Riemann.RiemannConf.create(tags = ["riemann-health"])) (PointName.ofSingle "riemann")
        Console.create Console.empty (PointName.ofSingle "console")
      ] >>
      withMetrics (Duration.FromMilliseconds 5000L) [
        WinPerfCounters.create (WinPerfCounters.Common.cpuTimeConf) (PointName.ofSingle "wperf")(Duration.FromMilliseconds 300L)
      ] >>
      withRules [
        Rule.createForTarget (PointName.ofSingle "riemann")
        Rule.createForTarget (PointName.ofSingle "console")
      ] >>
      withInternalTargets Info [
        Console.create (Console.empty) (PointName.ofSingle "console")
      ]
    ) |> Hopac.TopLevel.run

  Console.ReadKey true |> ignore
  0
```

Now you can get a logger through the `Logging` module:

**F#**

``` fsharp
let logger = Logging.getCurrentLogger ()
let another = Logging.getLoggerByName "Corp.App.Svc"
let writeLog x = Logary.Logger.log logger x |> Hopac.TopLevel.start
Logary.Message.eventDebug "test" |> writeLog
```

or in **C#**
``` csharp
namespace A {
  class X {
    static readonly Logger _logger = Logging.GetCurrentLogger();
    void XX () {
      _logger.Info("hello world");
    }
  }
}
```

The Logger module will automatically discover the current
call-site/function/module/class.and use its hierarchy to create a new logger.
The idea is that you can use Rule.hiera regexpes to selectively enable or
disable loggers, just like you can in NLog and log4net.

The static logger is automatically wired up to the framework the instant that
you run the `withLogary'` or `runWithGoodDefaults` from the
`Logary.Configuration` namespace (in which you find the `Config` module).

## HealthChecks, Metrics, Probes

Health Checks are like probes, but know how to interpret the results into the
warning-levels of `LogLevel`.

Metrics: This is currently fairly well-working - have a look at the SQLHealthService for
an example of a Probe.


## C# & VB façade

This facade is useful when you're using C# 

``` powershell
Install-Package Logary.CSharp
```

It adds extension methods to the `Logary` namespace. Just import the namespace
to get access to the extension methods, while having the nuget/dll referenced.

``` csharp
using System;
using System.Data.SQLite;
using System.Text.RegularExpressions;
using FluentMigrator.Runner.Announcers;
using FluentMigrator.Runner.Generators.SQLite;
using FluentMigrator.Runner.Processors.Sqlite;
using Logary;
using Logary.Configuration;
using Logary.DB.Migrations;
using Logary.Target;
using Console = System.Console;

namespace Logary.Specs.Examples
{
    public class When_using_fluent_API
    {
        public void UsageExample()
        {
            var x = LogaryFactory.New("Logary Specs",
                with => with.Target<TextWriter.Builder>(
                    "console1",
                    conf =>
                    conf.Target.WriteTo(Console.Out, Console.Error)
                        .MinLevel(LogLevel.Verbose)
                        .AcceptIf(line => true)
                        .SourceMatching(new Regex(".*"))
                    )
                    .Target<Graphite.Builder>(
                        "graphite",
                        conf => conf.Target.ConnectTo("127.0.0.1", 2131)
                    )
                    .Target<Debugger.Builder>("debugger")
                    .Target<Logstash.Builder>(
                        "ls",
                        conf => conf.Target
                            .Hostname("localhost")
                            .Port(1936)
                            .EventVersion(Logstash.EventVersion.One)
                            .Done())
                    .Target<DB.Builder>("db",
                        conf => conf.Target
                            .ConnectionFactory(() => new SQLiteConnection())
                            .DefaultSchema()
                            .MigrateUp(
                                conn => new SqliteProcessor(conn,
                                    new SqliteGenerator(),
                                    new ConsoleAnnouncer(),
                                    new MigrationOptions(false, "", 60),
                                    new SqliteDbFactory())))
                );

            var logger = x.GetLogger("Sample.Config");

            logger.Log("Hello world", LogLevel.Debug, new
                {
                    important = "yes"
                });

            logger.Log(LogLevel.Fatal, "Fatal application error on finaliser thread");

            logger.Verbose("immegawd immegawd immegawd!!", "tag1", "tag2");

            var val = logger.TimePath("sample.config.compute_answer_to_everything", () =>
                {
                    for (int i = 0; i < 100; i++)
                        System.Threading.Thread.Sleep(1);

                    return 32;
                });

            logger.LogFormat(LogLevel.Warn, "{0} is the answer to the universe and everything", val);

            logger.Time(() => logger.Debug("I wonder how long this takes", "introspection", "navel-gazing"));

            try
            {
                throw new ApplicationException("thing went haywire");
            }
            catch (Exception e)
            {
                logger.DebugException("expecting haywire, so we're telling with debug", e, "haywire", "external");
            }
        }
    }
}
```
