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

func extractElements*(parsedEq: ChemicalEquation): HashSet[string] =
  for side_i in 0..<2:
    for molecule in parsedEq[side_i]:
      for elem in molecule.keys:
        result.incl elem

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
    
    molecule <- >{'e', 'p'} | +simpleMolecule * ?(>{'+', '-'} * >*Digit):
      
      if capture.len == 2:
        let charge = if $1 == "p": +1 else: -1
        d.finished.inc "q", charge

      elif capture.len == 3:
        let
          chargeKind = if $1 == "+": +1 else: -1
          chargeNum = specialParseInt $2
        
        d.finished.inc "q", chargeNum * chargeKind

  var data: MPData
  doAssert moleculeParserNpeg.match(mstr, data).ok, fmt"'{mstr}' didn't matched"
  data.finished

proc equationParser*(eq: string): ChemicalEquation =
  doAssert "=>" in eq, "the equation doesn't have '=>'"

  let
    eqSides = eq.replace(" ", "").split("=>")
    res = eqSides.mapIt (it.split re"\+(?=[A-Z]|\()").mapIt it.moleculeParser

  [res[0], res[1]]
