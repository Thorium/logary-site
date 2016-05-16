# File - Logary Target

The file target is currently a planned target. If you really want to log to
file, in the mean while, use `System.IO.File.OpenWrite` and pass the
`TextWriter` you get back, to the `TextWriter` target.

See: https://logary.github.io/targets/textwriter/
