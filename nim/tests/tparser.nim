import unittest, tables, sequtils,  sets
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

  test "Fe2(SO4)3":
    check moleculeParser("Fe2(SO4)3") ==
      {"Fe": 2, "S": 3, "O": 12}.toTable
  
  test "IO3-":
    check moleculeParser("IO3-") ==
      {"I": 1, "O": 3, "q": -1}.toTable

  test "Fe+2":
    check moleculeParser("Fe+2") ==
      {"Fe": 1, "q": +2}.toTable

  test "e":
    check moleculeParser("e") ==
      {"q": -1}.toTable

  test "p":
    check moleculeParser("p") ==
      {"q": +1}.toTable

suite "equationParser":
  test "check '+ ('":
    let peq = equationParser "Fe+2 + (NH3)3 => Fe + N + H"

    check:
      peq[0].anyIt it.getOrDefault("H") == 9 and it.getOrDefault("N") == 3
      peq[0].anyIt it.getOrDefault("q") == +2 and it.getOrDefault("Fe") == 1


suite "extractElements":
  test "H + He + p + Fe2O3 + Zn => HHe + ZnHe4 + Fe":
    let elemstSet = extractElements equationParser "H + He + p + Fe2O3 + Zn => HHe + ZnHe4 + Fe"
    check elemstSet == ["Fe", "H", "He", "q", "Zn", "O"].toHashSet