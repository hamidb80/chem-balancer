import sequtils
import parser

proc solver(eq:string)=
  let
    parsedEq = equationParser eq
    atoms = toSeq atomsSet eq

  # NaCl => Na + Cl
  {
    "Cl": [[1], [0, 1]],
    "Na": [[1], [0, 1]]
  }




