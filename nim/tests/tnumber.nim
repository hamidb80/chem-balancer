import unittest
import number

suite "operations":
  test "subtraction 8\\3 - 1\\2":
    check 8\3 - 1\2 == 13\6

  test "summation 8\\3 + 1\\2":
    check 8\3 + 1\2 == 19\6

  test "multipication 8\\3 * 1\\2":
    check (8\3) * (1\2) == (8\6)

  test "devision 8\\3 / 1\\2":
    check (8\3) / (1\2) == 16\3

suite "functionalities":
  test "simplify":
    check (simplify 45\3)  == 15\1
    check (simplify 44\3)  == 44\3
    check (simplify 120\4)  == 60\2