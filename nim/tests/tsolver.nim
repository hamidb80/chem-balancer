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

  test "(NH4)2(HO)2 => NH4 + HO":
    check eqSolver("(NH4)2(HO)2 => NH4 + HO") == @[1 ,2 ,2]

  test "Fe2(SO4)3 => Fe + SO4":
    check eqSolver("Fe2(SO4)3 => Fe + SO4") == @[1 ,2 ,3]

  test "FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4":
    check eqSolver("FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4") == @[3, 2 ,1 ,3]

  
  
  # add more tests
  # "A + B => C + D"
  # 'I cant balance it!'