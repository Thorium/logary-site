# Targets Overview

These are the targets supported by Logary. If you write a target, then send a PR
towards this documentation and everyone can enjoy using it!

Some targets have been extensively tested and some less. We have the same
milestone-model as [logstash](http://logstash.net/docs/1.4.2/plugin-milestones):

### Milestone 0

Development on this target has just begun and you can't expect everything, if
anything, to work. If you are interested in the functionality, please
contribute your time!

### Milestone 1

Plugins at this milestone need your feedback to improve! Plugins at this
milestone may change between releases as the community figures out the best way
for the plugin to behave and be configured.

### Milestone 2

Plugins at this milestone are more likely to have backwards-compatibility to
previous releases than do Milestone 1 plugins. This milestone also indicates a
greater level of in-the-wild usage by the community than the previous milestone.

### Milestone 3

Plugins at this milestone have strong promises towards backwards-compatibility.
This is enforced with automated tests to ensure behavior and configuration are
consistent across releases.

## Available Targets

Target                                | Capabilities      | Milestone
:------------------------------------ | :---------------: | -----------:
[TextWriter](textwriter.md)           | LogLine, Measure  | 3
[Console](console.md)                 | LogLine,          | 3
[Debugger](debugger.md)               | LogLine, Measure  | 3
[Logstash](logstash.md)               | LogLine           | 3
[Graphite](graphite.md)               | Measure           | 1
[Elmah.IO](elmahio.md)                | LogLine           | 2
[Logentries](logentries.md)           | LogLine           | 1
[Riemann](riemann.md)                 | LogLine           | 2
[DB](db.md)                           | LogLine, Measure  | 2
[Dash](dash.md)                       | LogLine, Measure  | 0
[ZipKin](zipkin.md)                   | LogLine, Measure  | 0
