import
  strutils, strformat,
  sequtils, sets,
  re, 
  tables
import npeg

type
  ElementsCount* = CountTable[string]
  ChemicalEquation* = array[2, seq[ElementsCount]]
  
  MPData = object # molecule parser data
    temp: ElementsCount
    finished: ElementsCount

func atomsSet*(eq: string): HashSet[string]=
  for atom in eq.findAll(re"[A-Z][a-z]?"):
    result.incl atom

func specialParseInt(snum: string): int =
  if snum == "": 1
  else: parseInt snum

proc moleculeParser*(mstr: string): ElementsCount =
  const moleculeParserNpeg = peg("molecule", d: MPData):
    atom <- Upper * ?Lower
    element <- >atom * >*Digit:
      d.temp.inc $1, specialParseInt $2

    simpleMolecule <- +element | '(' * +element * ')' * >*Digit:
      let coeff =
        if capture.len == 2: specialParseInt $1
        else: 1

      for (e, n) in d.temp.pairs:
        d.finished.inc e, n * coeff
      d.temp.clear

    molecule <- +simpleMolecule

  var data: MPData
  doAssert moleculeParserNpeg.match(mstr, data).ok, fmt"'{mstr}' didn't matched"
  data.finished

proc equationParser*(eq: string): ChemicalEquation =
  doAssert "=>" in eq, "the equation doesn't have '=>'"
  let eqSides = eq.replace(" ", "").split("=>")
  doAssert eqSides[0].atomsSet == eqSides[1].atomsSet, "some atoms are not in the both sides"

  let res =
    eqSides.mapIt (it.split '+').mapIt it.moleculeParser
  
  [res[0], res[1]]