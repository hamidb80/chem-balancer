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
  for n in l:
    if n != 0:
      return l.mapIt it / n

proc specialSort*(mat: Matrix): Matrix=
  # remove duplicated rows e.g. [4,0 ,2] , [2, 0, 1]
  result = (mat.mapIt it.devideByFirstNonZeroCell).toHashSet.toSeq
  let minLen = min(result.len, result[0].len)

  template foundThem(i,j: int):untyped=
    swap result[i], result[j]
    found = true
    break search

  for i in 0..<minLen: # sort by matrix[i][i] is not 0
    var found = false
    
    block search:
      for a in i..<result.len:
        if result[a][i] != 0: # try to find a row
          foundThem i, a
        else: # try to replace with other rows
          for b in 0..<i:
            # [1,0,0,1]
            # ...
            # ...
            # [1,2,1,0]
            if result[b][i] != 0 and result[a][b] != 0:
              foundThem a, b
            else:
              debugEcho "check ", a, " with ", b, " failed"
              debugEcho result[b], i, " is ", result[b][i]
              debugEcho result[a], b, " is ", result[a][b]
              debugEcho "in mat \n", result

    if not found:
      debugEcho "for row ", i
      debugEcho "in matrix \n", mat
      debugEcho "res so far \n", result
      raise newException(ValueError, "is not solvable")
  
func createCoeffMatrixFromEq*(parsedEq: ChemicalEquation): seq[seq[int]] =
  for elem in extractElements(parsedEq).items:
    result.add newSeq[int]()

    for (i, coeff) in [(0, 1), (1, -1)].items:
      for molecule in parsedEq[i]:
        let num = molecule.getOrDefault(elem, 0)
        result[^1].add num * coeff

proc eqSolver*(eq: string): seq[int] =
  let parsedEq = equationParser eq
  var
    coeffMatrix = createCoeffMatrixFromEq(parsedEq).toMatrix
    ans = repeat(0, coeffMatrix.len).toList

  doAssert ans.len == coeffMatrix.len

  let diff = coeffMatrix.len - coeffMatrix[0].len
  template cutUseless[T](list: var seq[T]): untyped=
    # list = list.slice
    discard

  ans.cutUseless
  coeffMatrix.cutUseless
    
  # assume the last unknown variable is 1
  coeffMatrix.add concat(repeat(0\1, coeffMatrix[0].len - 1), @[1\1])
  ans.add 1\1
  # -------------

  for i in 0..<coeffMatrix.len:
    coeffMatrix[i].add ans[i]

  coeffMatrix = specialSort coeffMatrix

  for i in 0..<coeffMatrix.len:
    ans[i] = coeffMatrix[i].pop 
  # -------------

  let pureCoeffs = guassianSolveLinearAlgebra(coeffMatrix, ans)
  var commonLcm = pureCoeffs[0].down
  for i in 1..<pureCoeffs.len:
    commonLcm = lcm(commonLcm, pureCoeffs[i].down)

  for n in pureCoeffs:
    result.add (commonLcm * n).toInt
