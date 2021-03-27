import unittest
import number, matrix

suite "matrix":
  test "solve linear algebra":
    check guassianSolveLinearAlgebra(
      @[
        @[1,0],
        @[0,8]
     ].toMatrix,
      @[0, 3].toList
    ) == @[initSNumber(0), initSNumber(3,8)]