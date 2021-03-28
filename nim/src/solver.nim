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
            if result[b][i] != 0 and result[a][b] != 0:
              foundThem a, b

            # FIXME: in row index 3 cannot find replacement
            # [1, 0, (-1/2), 0]
            # [1, (-2/5), (-1/10), 0]
            # [0, 0, 1, 1]
            # [1, (-1/2), 0, 0]

    if not found:
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

  # --- sort
  for i in 0..<coeffMatrix.len:
    coeffMatrix[i].add ans[i]

  coeffMatrix = specialSort coeffMatrix

  ans = @[].toList
  for i in 0..<coeffMatrix.len:
    ans.add coeffMatrix[i].pop 

  let diff = coeffMatrix.len - coeffMatrix[0].len
  # if diff > 0:
  #   raise newException(ValueError, "What??")
  if diff == 0:
    discard coeffMatrix.pop
    discard ans.pop
  # assume the last unknown variable is 1
  coeffMatrix.add concat(repeat(0\1, coeffMatrix[0].len - 1), @[1\1])
  ans.add 1\1
  
  
  # remove useless rows
  # if coeffMatrix.len != coeffMatrix[0].len:
  #   ans = ans[0..<coeffMatrix.len]
  #   coeffMatrix = coeffMatrix[0..<coeffMatrix.len]

  let ansCoeffs = guassianSolveLinearAlgebra(coeffMatrix, ans)
  var commonLcm = ansCoeffs[0].down
  for i in 1..<ansCoeffs.len:
    commonLcm = lcm(commonLcm, ansCoeffs[i].down)

  for n in ansCoeffs:
    result.add (commonLcm * n).toInt
