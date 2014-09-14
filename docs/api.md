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
    withLogary' "Riemann.Example" (
      withTargets [
        Riemann.create (Riemann.RiemannConf.Create(tags = ["riemann-health"])) "riemann"
        Console.create (Console.ConsoleConf.Default) "console"
      ] >>
      withMetrics (Duration.FromMilliseconds 5000L) [
        WinPerfCounters.create (WinPerfCounters.Common.cpuTime) "cpuTime" (Duration.FromMilliseconds 500L)
      ] >>
      withRules [
        Rule.forAny "riemann"
        Rule.forAny "console"
      ] >>
      withInternalTargets Info [
        Console.create (Console.ConsoleConf.Default) "console"
      ]
    )

  Console.ReadKey true |> ignore
  0
```

## HealthChecks, Metrics, Probes

Health Checks are like probes, but know how to interpret the results into the
warning-levels of `LogLevel`.

Metrics: This is currently fairly well-working - have a look at the SQLHealthService for
an example of a Probe.


## C# & VB façade

This facade is useful when you're using C# 

``` powershell
Install-Package Intelliplan.Logary.CSharp -Pre
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

namespace Intelliplan.Logary.Specs.Examples
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
