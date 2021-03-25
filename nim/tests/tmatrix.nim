import unittest
import number, matrix

suite "solver":
  test "specialSort":
    check specialSort(toMatrix @[
      @[0,2,0, 3],
      @[1,5,7, 3],
      @[1,4,1, 3],
      @[0,0,0, 3]
    ]) == toMatrix @[
      @[1,5,7, 3],
      @[0,2,0, 3],
      @[1,4,1, 3],
      @[0,0,0, 3]
    ]
  
  test "solve linear algebra":
    check guassianSolveLinearAlgebra(
      @[
        @[1,0],
        @[0,8]
     ].toMatrix,
      @[0, 3].toList
    ) == @[initSNumber(0), initSNumber(3,8)]

