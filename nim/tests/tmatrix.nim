import unittest
import number, matrix

suite "solve linear algebra":
  test "2x2 (1":
    check guassianSolveLinearAlgebra(
      @[
        @[1, 0],
        @[0, 8]
      ].toMatrix,
       @[0, 3].toList
    ) == @[0\1, 3\8]

  test "2x2 (2":
    check guassianSolveLinearAlgebra(
      @[
        @[1, 2],
        @[3, 8]
      ].toMatrix,
       @[5\2, 19\2]
    ) == @[1\2, 1\1]

  test "3x3":
    check guassianSolveLinearAlgebra(
      @[
        @[1, 0, 2],
        @[2, 1, 1],
        @[1, 1, 2]
      ].toMatrix,
       @[5, 9, 7].toList
    ) == @[3, 2, 1].toList

  test "4x4 (1":
    check guassianSolveLinearAlgebra(
      @[
        @[2, 3, 0, 0],
        @[1, 4, 0, 1],
        @[0, 1, 1, 4],
        @[2, 0, 0, 2]
      ].toMatrix,
       @[19, 26, 41, 28].toList
    ) == @[5, 3, 2, 9].toList

  test "4x4 (2":
    check guassianSolveLinearAlgebra(
      @[
        @[1, 3, 0, 0],
        @[1, 4, 0, 1],
        @[0, 1, 1, 4],
        @[2, 0, 0, 2]
      ].toMatrix,
       @[5\1, 71\10, 49\10, 22\10]
    ) == @[1\2, 3\2, 1\1, 3\5]

  test "5x5":
    check guassianSolveLinearAlgebra(
      @[
        @[4, 3, 0, 1, 0],
        @[1, 0, 6, 5, 6],
        @[9, 9, 6, 1, 1],
        @[0, 1, 1, 4, 0],
        @[2, 0, 0, 2, 0]
      ].toMatrix,
       @[71\1, 45\1, 171\1, 31\3, 38\1]
    ) == @[17\1, 1\3, 2\1, 2\1, 1\1]


suite "functionalities":
  test "transpose":
    check transpose(
      @[
        @[1, 2, 3],
        @[4, 5, 6],
        @[7, 8, 9]
      ].toMatrix
    ) == @[
        @[1, 4, 7],
        @[2, 5, 8],
        @[3, 6, 9]
      ].toMatrix
