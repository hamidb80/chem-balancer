import 
  tables,
  sets,
  sequtils,
  math
import parser ,matrix, number

proc eqSolver*(eq: string): seq[int] =
  let
    parsedEq = equationParser eq
    atoms = atomsSet eq

  var 
    coeffMatrix: seq[seq[int]]
    ans: seq[int]
  for atom in atoms.items:
    coeffMatrix.add newSeq[int]()
    ans.add 0
    
    for (i, coeff) in [(0,1), (1, -1)].items:
      for molecule in parsedEq[i]:
        let num = molecule.getOrDefault(atom, 0)
        coeffMatrix[^1].add num * coeff
  
  # coeffMatrix:
  # "Al + Fe2O3 => Fe + Al2O3"
  # {
  #   "Al": [1, 0, 0, -2],
  #   "Fe": [0, 2, -1, 0],
  #   "O":  [0, 3, 0, -3]
  # }

  let diff = coeffMatrix[0].len - coeffMatrix.len
  if diff > 1:
    raise newException(ValueError, "how is it even possible?!?") 
  
  # assume the last unknown variable is 1
  coeffMatrix.add concat(repeat(0, coeffMatrix[0].len - 1), @[1])
  ans.add 1

  let pureCoeffs = guassianSolveLinearAlgebra(coeffMatrix.toMatrix, ans.toList)
  
  var commonLcm = pureCoeffs[0].down
  for i in 1..<pureCoeffs.len:
    commonLcm = lcm(commonLcm, pureCoeffs[i].down)

  for n in pureCoeffs:
    result.add (commonLcm * n).toInt