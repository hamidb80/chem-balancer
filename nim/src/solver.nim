import 
  tables,
  sets,
  sequtils,
  algorithm

import parser , matrix, number

func sortByZeros*(s: Matrix): Matrix=
  var temp: seq[CmpList]
  
  for list in s:
    var count = 0
    for num in list:
      if num == 0: inc count
      else: break
    temp.add (count, list)

  sorted(temp, cmp, Ascending).mapIt it.s


## solve n eq n unknowns with guass method
proc solveLinearAlgebra*(A: Matrix, b: List): List=
  if A.len == 1:
    return @[b[0]]

  # Al + Fe2O3 => Fe + Al2O3
  # {
  #   "Al": [1,  0,  0, -2],
  #   "Fe": [0,  2, -1,  0],
  #   "O":  [0,  3,  0, -3]
  # }

  # sort rows by the number of first zeroes
  var M = sortByZeros A
  for i in 0..<A.len:
    M[i].add b[i] # add answer column

  for y in 1..<M.len: # make up triangle matrix 
    let answers = solveLinearAlgebra(M[0..<y].mapIt it[0..<y], M[y][0..<y])

    for i in 0..<answers.len:
      for x in 0..<M[y].len:
        M[y][x] += answers[i] * M[(y - 1) - i][x]


  # making the main diameter 1
  for d in 0..<M.len:
    let k = M[d][d]
    for x in 0..<M[d].len:
      M[d][x] /= k

  # ------------

proc eqSolver*(eq: string) =
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

  # i'm not sure now maybe it always happens 
  elif diff == 1: # assign the last unknown to 1
    coeffMatrix.add concat(repeat(0, coeffMatrix[0].len - 1), @[1])
    ans.add 1

  echo ":: ans :: \n", solveLinearAlgebra(coeffMatrix.toMatrix, ans.toList)



eqSolver "Al + Fe2O3 => Fe + Al2O3"
# eqSolver "CH4 + O2 => CO2 + H2O"
# eqSolver "O2 + H2 => H2O"
# eqSolver "O2 => O3"