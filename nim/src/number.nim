import math, strformat
import utils

type
  SNumber* = ref object # special integer number
    up*: int
    down*: int

func simplify*(n: SNumber): SNumber =
  let k = gcd(n.up, n.down)

  let coeff = if n.down < 0: -1 else: +1

  SNumber(
    up: (n.up div k) * coeff,
    down: n.down div k * coeff
  )

func initSNumber*(u: int = 0, d: int = 1): SNumber =
  doAssert d != 0
  simplify SNumber(up: u, down: d)

func `toInt`*(n: SNumber): int =
  if n.down != 1:
    raise newException(ValueError, "cannot convert float into int")

  return n.up

func commonDown*(a, b: var SNumber) =
  let downLcm = lcm(a.down, b.down)

  template makeup(a: var SNumber): untyped =
    a.up = downLcm div a.down * a.up
    a.down = downLcm

  makeup a
  makeup b

func `$`*(n: SNumber): string =
  if n.up == 0 or n.down == 1:
    $n.up
  else:
    fmt"({n.up}/{n.down})"

# ----------------- operators -----------------

func `+`*(a, b: SNumber): SNumber =
  let downLcm = lcm(a.down, b.down)

  template upSum(a): untyped =
    downLcm div a.down * a.up

  simplify SNumber(
    up: (upSum a) + (upSum b),
    down: downLcm
  )

func `-`*(a, b: SNumber): SNumber {.inline.} =
  `+`a, SNumber(up: -b.up, down: b.down)

func `-`*(a: SNumber): SNumber {.inline.} =
  SNumber(up: -a.up, down: a.down)

func `*`*(a: SNumber, b: int): SNumber {.switchableArgs, inline.} =
  simplify SNumber(up: a.up * b, down: a.down)

func `/`*(a: SNumber, b: int): SNumber {.inline.} =
  doAssert b != 0
  simplify SNumber(up: a.up, down: a.down * b)

func `*`*(a, b: SNumber): SNumber {.inline.} =
  simplify SNumber(up: a.up * b.up, down: a.down * b.down)

func `/`*(a, b: SNumber): SNumber {.inline.} =
  doAssert b.up != 0
  simplify SNumber(up: a.up * b.down, down: a.down * b.up)

template `+=`*(a: var SNumber, b: SNumber): untyped =
  a = a + b

template `-=`*(a: var SNumber, b: SNumber): untyped =
  a = a - b

template `/=`*(a: var SNumber, b: SNumber): untyped =
  a = a / b

func `==`*(a: SNumber, b: int): bool {.switchableArgs, inline.} =
  b == 0 and a.up == 0 or a.down == 1 and a.up == b

func `==`*(a, b: SNumber): bool =
  if a.up == 0 and b.up == 0:
    return true

  var
    A = a
    B = b

  commonDown A, B
  a.up == b.up and a.down == b.down
