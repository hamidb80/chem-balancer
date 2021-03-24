import 
  strformat,
  strutils
import number

type 
  List* = seq[SNumber]
  Matrix* = seq[List]
  CmpList* = tuple[n: int, s: List]

func `$`*(m: Matrix): string=
  for row in m:
    let s = row.join ", "
    result.add &"[{s}]\n"

func toMatrix*(m: seq[seq[int]]): Matrix=
  for y in 0..<m.len:
    result.add newSeq[SNumber]()
    for x in 0..<m[y].len:
      result[^1].add initSNumber m[y][x]

func toList*(s: seq[int]): List=
  for i in 0..<s.len:
    result.add initSNumber s[i]

func `==`*(m1,m2: Matrix): bool=
  if m1.len != m2.len or m1[0].len != m2[0].len:
    return false
  
  for y in 0..<m1.len:
    for x in 0..<m1[0].len:
      if m1[y][x] != m2[y][x]:
        return false
  true

func cmp*(a,b: CmpList): int=
  system.cmp[int](a.n, b.n)