# Refactor notes: Logary notes impl metrics

Moving towards a dashboard with full metrics, health check and log line support.

## Step one - primitives

Creating the infrastructure to hoise `PerformanceCounter` and `/proc` polling
and continuous running on SQL statements into a probe.

 - Make *metric* an actor interface like *probe*
 - Make probe similar to *metric* at first
 - Create a scheduling actor that can run `sample` on the probes and metrics
 - A console text-writer target for the above sample

### Outstanding Questions

Handling of histograms as opposed to simple reservoirs of data?

## Step two - logary integration

Tying metrics, probes, health checks together with targets (reporters) and the registry (+ scheduler).

 - Register and unregister sampled metric in `Registry`
 - Register and unregister sampled probe in `Registry`
 - Register and unregister sampled health check in `Registry`
 - All three above are *never* *sampled* unless:
 - Use a `Rule` to connect a metric to a target, by specifying what *data point* to use as a gauge. This just calls *get_value* on a metric above.

## Step three - creating custom probes

When the infrastructure is in place, we can create probes that solve common problems.

 - Proof of concept probe that uses Göran's SQL for SQL Server to continuously report metrics.


## Step four - documenting the above

 - [Document](https://github.com/tpetricek/FSharp.Formatting/issues/167#issuecomment-49972190) how metrics, probes and health checks work and how they differ
 - Document order of initialisation
 - Document how to create custom (metric|probe|health check)
 - Document CLR perf counters, finish writing most common counters

## Step five - Health Checks, Probes

 - Create health check samples
 - Create probe samples and handling failing external subsystems?

## Step six - integrate new F# Actors?

[Colin doing work to freeze API](https://github.com/colinbull/Fsharp.Actor/commits/develop)

## Step seven - using a dashboard

The above is useless without a nice way to report the values. Create an in-app dashboard that can be used to access the histograms, guages and timers.

Let's just use the Apache 2.0 licensed [Metrics.Net](https://github.com/haf/Metrics.NET.FlotVisualization) dashboard.

[Extend with JsonDiffPatch](https://github.com/benjamine/JsonDiffPatch) to avoid sending full state every time.

Instead of polling, open a Server-Sent Event socket and get all patches from there, continuously applying it to the in-memory rep.

Make sure we can report same data:

```
{
  "Timestamp":"2014-07-26T22:54:52.6894+02:00",
  "Gauges":{
      ".NET Mb in all Heaps":732.27,
      ".NET Time in GC":7.94,
      "Contention Rate / Sec":0.00,
      "Exceptions Thrown / Sec":0.00,
      "Logical Threads":28.00,
      "Mb in all Heaps":4.36,
      "Physical Threads":25.00,
      "Queue Length / sec":0.00,
      "SampleMetrics.DataValue":3628800.00,
      "System AvailableRAM":1245.00,
      "System CPU Usage":27.55,
      "System Disk Reads/sec":0.01,
      "System Disk Writes/sec":0.00,
      "Time in GC":0.06,
      "Total Exceptions":465.00
    },
  "Counters":{
      "NancyFx.ActiveRequests":0,
      "SampleMetrics.ConcurrentRequests":7,
      "SampleMetrics.Requests":730
    },
  "Meters":{
      "NancyFx.Errors":{
          "Count":0,
          "MeanRate":0.00,
          "OneMinuteRate":0.00,
          "FiveMinuteRate":0.00,
          "FifteenMinuteRate":0.00
        },
      "SampleMetrics.Requests":{
          "Count":730,
          "MeanRate":3.82,
          "OneMinuteRate":3.93,
          "FiveMinuteRate":4.98,
          "FifteenMinuteRate":5.59
        }
    },
  "Histograms":{
      "NancyFx.PostAndPutRequestsSize":{
          "Count":0,
          "LastValue":0.00,
          "Min":0.00,
          "Mean":0.00,
          "Max":0.00,
          "StdDev":0.00,
          "Median":0.00,
          "Percentile75":0.00,
          "Percentile95":0.00,
          "Percentile98":0.00,
          "Percentile99":0.00,
          "Percentile999":0.00,
          "SampleSize":0
        },
      "SampleMetrics.ResultsExample":{
          "Count":730,
          "LastValue":3471.00,
          "Min":-4942.00,
          "Mean":105.35,
          "Max":4995.00,
          "StdDev":2866.55,
          "Median":213.00,
          "Percentile75":2576.00,
          "Percentile95":4530.00,
          "Percentile98":4934.00,
          "Percentile99":4939.00,
          "Percentile999":4995.00,
          "SampleSize":730
        },
      "SampleModule.TestRequest.Size":{
          "Count":0,
          "LastValue":0.00,
          "Min":0.00,
          "Mean":0.00,
          "Max":0.00,
          "StdDev":0.00,
          "Median":0.00,
          "Percentile75":0.00,
          "Percentile95":0.00,
          "Percentile98":0.00,
          "Percentile99":0.00,
          "Percentile999":0.00,
          "SampleSize":0
        },
      "SampleModule.TestRequestSize":{
          "Count":0,
          "LastValue":0.00,
          "Min":0.00,
          "Mean":0.00,
          "Max":0.00,
          "StdDev":0.00,
          "Median":0.00,
          "Percentile75":0.00,
          "Percentile95":0.00,
          "Percentile98":0.00,
          "Percentile99":0.00,
          "Percentile999":0.00,
          "SampleSize":0
        }
    },
  "Timers":{
      "NancyFx.GET [/metrics/health]":{
          "Rate":{
              "Count":36,
              "MeanRate":0.19,
              "OneMinuteRate":0.21,
              "FiveMinuteRate":0.20,
              "FifteenMinuteRate":0.20
            },
          "Histogram":{
              "Count":36,
              "LastValue":425.69,
              "Min":330.85,
              "Mean":382.34,
              "Max":435.18,
              "StdDev":26.54,
              "Median":381.06,
              "Percentile75":403.76,
              "Percentile95":427.11,
              "Percentile98":435.18,
              "Percentile99":435.18,
              "Percentile999":435.18,
              "SampleSize":36
            }
        },
      "NancyFx.GET [/metrics/json]":{
          "Rate":{
              "Count":732,
              "MeanRate":3.94,
              "OneMinuteRate":4.32,
              "FiveMinuteRate":2.44,
              "FifteenMinuteRate":1.56
            },
          "Histogram":{
              "Count":732,
              "LastValue":3.79,
              "Min":2.31,
              "Mean":7.55,
              "Max":408.84,
              "StdDev":19.57,
              "Median":3.31,
              "Percentile75":3.92,
              "Percentile95":39.78,
              "Percentile98":61.07,
              "Percentile99":71.70,
              "Percentile999":408.84,
              "SampleSize":732
            }
        },
      "NancyFx.GET [/metrics]":{
          "Rate":{
              "Count":3,
              "MeanRate":0.02,
              "OneMinuteRate":0.02,
              "FiveMinuteRate":0.11,
              "FifteenMinuteRate":0.16
            },
          "Histogram":{
              "Count":3,
              "LastValue":0.13,
              "Min":0.13,
              "Mean":26.05,
              "Max":77.86,
              "StdDev":44.87,
              "Median":0.16,
              "Percentile75":77.86,
              "Percentile95":77.86,
              "Percentile98":77.86,
              "Percentile99":77.86,
              "Percentile999":77.86,
              "SampleSize":3
            }
        },
      "NancyFx.Requests":{
          "Rate":{
              "Count":771,
              "MeanRate":4.03,
              "OneMinuteRate":4.56,
              "FiveMinuteRate":2.11,
              "FifteenMinuteRate":0.95
            },
          "Histogram":{
              "Count":771,
              "LastValue":3.78,
              "Min":0.11,
              "Mean":25.10,
              "Max":435.15,
              "StdDev":81.60,
              "Median":3.33,
              "Percentile75":4.15,
              "Percentile95":79.62,
              "Percentile98":388.93,
              "Percentile99":408.69,
              "Percentile999":435.15,
              "SampleSize":771
            }
        },
      "SampleMetrics.Requests":{
          "Rate":{
              "Count":723,
              "MeanRate":3.78,
              "OneMinuteRate":3.83,
              "FiveMinuteRate":4.64,
              "FifteenMinuteRate":5.09
            },
          "Histogram":{
              "Count":723,
              "LastValue":472.59,
              "Min":10.99,
              "Mean":1393.96,
              "Max":2998.03,
              "StdDev":875.90,
              "Median":1282.13,
              "Percentile75":2145.02,
              "Percentile95":2892.10,
              "Percentile98":2949.10,
              "Percentile99":2994.81,
              "Percentile999":2998.03,
              "SampleSize":217
            }
        },
      "SampleModule.TestRequest.Time":{
          "Rate":{
              "Count":0,
              "MeanRate":0.00,
              "OneMinuteRate":0.00,
              "FiveMinuteRate":0.00,
              "FifteenMinuteRate":0.00
            },
          "Histogram":{
              "Count":0,
              "LastValue":0.00,
              "Min":0.00,
              "Mean":0.00,
              "Max":0.00,
              "StdDev":0.00,
              "Median":0.00,
              "Percentile75":0.00,
              "Percentile95":0.00,
              "Percentile98":0.00,
              "Percentile99":0.00,
              "Percentile999":0.00,
              "SampleSize":0
            }
        }
    },
  "Units":{
      "Gauges":{
          ".NET Mb in all Heaps":"Mb",
          ".NET Time in GC":"%",
          "Contention Rate / Sec":"Attempts/s",
          "Exceptions Thrown / Sec":"Exceptions/s",
          "Logical Threads":"Threads",
          "Mb in all Heaps":"Mb",
          "Physical Threads":"Threads",
          "Queue Length / sec":"Threads/s",
          "SampleMetrics.DataValue":"$",
          "System AvailableRAM":"Mb",
          "System CPU Usage":"%",
          "System Disk Reads/sec":"kb/s",
          "System Disk Writes/sec":"kb/s",
          "Time in GC":"%",
          "Total Exceptions":"Exceptions"
        },
      "Counters":{
          "NancyFx.ActiveRequests":"ActiveRequests",
          "SampleMetrics.ConcurrentRequests":"Requests",
          "SampleMetrics.Requests":"Requests"
        },
      "Meters":{
          "NancyFx.Errors":"Errors/s",
          "SampleMetrics.Requests":"Requests/s"
        },
      "Histograms":{
          "NancyFx.PostAndPutRequestsSize":"bytes",
          "SampleMetrics.ResultsExample":"Items",
          "SampleModule.TestRequest.Size":"bytes",
          "SampleModule.TestRequestSize":"bytes"
        },
      "Timers":{
          "NancyFx.GET [/metrics/health]":{
              "Rate":"Requests/s",
              "Duration":"ms"
            },
          "NancyFx.GET [/metrics/json]":{
              "Rate":"Requests/s",
              "Duration":"ms"
            },
          "NancyFx.GET [/metrics]":{
              "Rate":"Requests/s",
              "Duration":"ms"
            },
          "NancyFx.Requests":{
              "Rate":"Requests/s",
              "Duration":"ms"
            },
          "SampleMetrics.Requests":{
              "Rate":"Requests/s",
              "Duration":"ms"
            },
          "SampleModule.TestRequest.Time":{
              "Rate":"Requests/s",
              "Duration":"ms"
            }
        }
    }
}
```

