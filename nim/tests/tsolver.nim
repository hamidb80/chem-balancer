import unittest
import solver

suite "equation balancer":
  test "CH4 + O2 => CO2 + H2O":
    check eqSolver("CH4 + O2 => CO2 + H2O") == @[1, 2, 1, 2]

  test "Al + Fe2O3 => Fe + Al2O3":
    check eqSolver("Al + Fe2O3 => Fe + Al2O3") == @[2, 1, 2, 1]

  test "O2 + H2 => H2O":
    check eqSolver("O2 + H2 => H2O") == @[1, 2, 2]

  test "O2 => O3":
    check eqSolver("O2 => O3") == @[3 ,2]
