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


task start, "run the app":
  exec "nim r src/main.nim"