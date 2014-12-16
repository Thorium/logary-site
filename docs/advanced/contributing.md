# Contribution Guidelines

Coding style: pascalCase, 2 space intent. Use feature branches, PR against
master. Use immutable data structures and tail recursion.

Use `module Logary.MyModule` or `module Logary.SubNs.MyModule`, not:

``` fsharp
namespace Logary.SubNs

module MyModule =
  ...
```

If introducing a new type + corresponding module (see `Measure.fs` for example):

Two-phase configuration; first create immutable configuration, then compile it.
Second step: create running instances of everything from the configuration. This
ensures that a logary instance is correct by construction.

