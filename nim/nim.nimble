# Package

version       = "0.1.0"
author        = "hamidb80"
description   = "chem equation balancer written in nim"
license       = "MIT"
srcDir        = "src"
bin           = @["nim"]


# Dependencies
requires "nim >= 1.4.2"
requires "npeg >= 0.24.1"
requires "benchy >= 0.0.1"

task build, "build app":
  exec "nim c -d:release src/main.nim"

task bench, "run benchmarks":
  exec "nim r -d:release tests/bench.nim"