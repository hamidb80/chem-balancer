import
  tables,
  sets,
  hashes,
  math,
  sequtils
import parser, matrix, number

func hash(s: SNumber): Hash =
  hash s.up / s.down

func devideByFirstNonZeroCell(l: List): List =
  var k = 0
  for c in l:
    if c != 0:
      k = c.toInt
      break

  l.mapIt it / k

func specialSort*(s: Matrix): Matrix =
  var # remove duplicated rows e.g. [4,0 ,2] , [2, 0, 1]
    m = (s.mapIt it.devideByFirstNonZeroCell).toHashSet.toSeq
  
  let org = m
  debugEcho "org1~:\n", org

  for i in 0..<min(s.len, s[0].len): # sort by matrix[i][i] is not 0
    var found = false
    
    for row_i in 0..<m.len:
      if m[row_i][i] != 0:
        result.add m[row_i]
        m.del row_i
        found = true
        break
    
    if not found:
      debugEcho "org2:\n", org
      debugEcho "mod:\n", m
      debugEcho "res:\n", result
      raise newException(ValueError, "is not solvable")
  
func createCoeffMatrixFromEq*(parsedEq: ChemicalEquation): seq[seq[int]] =
  for elem in extractElements(parsedEq).items:
    result.add newSeq[int]()

    for (i, coeff) in [(0, 1), (1, -1)].items:
      for molecule in parsedEq[i]:
        let num = molecule.getOrDefault(elem, 0)
        result[^1].add num * coeff

  # coeffMatrix:
  # "Al + Fe2O3 => Fe + Al2O3"
  # {
  #   "Al" [1, 0, 0, -2],
  #   "Fe" [0, 2, -1, 0],
  #   "O"  [0, 3, 0, -3]
  # }


proc eqSolver*(eq: string): seq[int] =
  let
    parsedEq = equationParser eq

  var
    coeffMatrix: seq[seq[int]] = createCoeffMatrixFromEq(parsedEq)
    ans: seq[int] = repeat(0, coeffMatrix[0].len - 1)

  let diff = coeffMatrix[0].len - coeffMatrix.len
  if diff > 1:
    raise newException(ValueError, "how is it even possible?!?")

  # sort coeff Matrix
  # assume the last unknown variable is 1
  coeffMatrix.add concat(repeat(0, coeffMatrix[0].len - 1), @[1])
  ans.add 1

  let pureCoeffs = guassianSolveLinearAlgebra(coeffMatrix.toMatrix, ans.toList)
  var commonLcm = pureCoeffs[0].down
  for i in 1..<pureCoeffs.len:
    commonLcm = lcm(commonLcm, pureCoeffs[i].down)

  for n in pureCoeffs:
    result.add (commonLcm * n).toInt
