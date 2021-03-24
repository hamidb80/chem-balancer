import unittest
import solver, number, math2d

func convert(m: seq[seq[int]]): Matrix=
  for y in 0..<m.len:
    result.add newSeq[SNumber]()
    for x in 0..<m[0].len:
      result[^1].add initSNumber m[y][x]

func convert(s: seq[int]): List=
  for i in 0..<s.len:
    result.add initSNumber s[i]


suite "solver":
  test "sort by zeros":
    check sortByZeros(toMatrix @[
      @[0,2,0],
      @[1,5,7],
      @[1,4,0],
      @[0,0,0]
    ]) == toMatrix @[
      @[1,5,7],
      @[1,4,0],
      @[0,2,0],
      @[0,0,0]
    ]
  
  test "solve linear algebra":
    check solveLinearAlgebra(
      @[
        @[1,2],
        @[3,4]
      ].toMatrix,
      @[4, 10].toList
    ) == @[2, 1].toList