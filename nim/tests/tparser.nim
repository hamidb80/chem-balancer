import tables, unittest, sets

import parser

func `==`[T](ct: CountTable[T], t: Table[T, int]): bool =
  for (k, v) in t.pairs:
    if ct.getOrDefault(k, 0) != v:
      return false
  true


suite "moleculeParser":
  test "He(NH4)2O2":
    check moleculeParser("He(NH4)2O2") ==
      {"He": 1, "N": 2, "H": 8,"O": 2}.toTable

  test "(NH4)(NO3)":
    check moleculeParser("(NH4)(NO3)") ==
      {"N": 2, "H": 4, "O": 3}.toTable
  
suite "atomsSet":
  test "He(NH4)2O2":
    check "He(NH4)2O2".atomsSet == toHashSet(["He", "N", "H", "O"])