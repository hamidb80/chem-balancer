import
  tables,
  sets, hashes,
  math,
  sequtils
import parser, matrix, number

func hash(s: SNumber): Hash =
  hash s.up / s.down

func devideByFirstNonZeroCell(l: List): List =
  for n in l:
    if n != 0:
      return l.mapIt it / n

## grm : graph relation matrix
## we want a path from a to b
func dfs*(grm: var seq[seq[bool]], a, b: int, visited: seq[int] = @[]): seq[int] =
  # block:
  #   debugEcho "new func call"
  #   debugEcho "visited: ", visited
  #   for row in grm:
  #     debugEcho row
  #   debugEcho "checking for ", a, "->", b

  template newVisited: untyped=
    visited & a

  for (i, v) in grm[a].pairs:
    # debugEcho (i,v), grm[a]
    if v:
      if i == b:
        # debugEcho "found them!", newVisited
        return newVisited & b

      elif i != a and i notin visited:
        # debugEcho "checking for ", i, "->", b
        let path = dfs(grm, i, b, newVisited)
        if path.len != 0:
          # debugEcho "found ", i, "->", b
          return visited & path

  # debugEcho "nothing for", a, "->", b

proc specialSort*(mat: Matrix): Matrix =
  # sort by matrix[i][i] is not 0
  # # remove duplicated rows e.g. [4,0 ,2] , [2, 0, 1]
  result = (mat.mapIt it.devideByFirstNonZeroCell).toHashSet.toSeq
  let minLen = min(result.len, result[0].len)

  for i in 0..<minLen:
    if result[i][i] != 0:
      continue

    # create a map graph from matrix
    var graph: seq[seq[bool]]=  newSeqWith(result.len, newSeqWith(result[0].len, false))
    for row in 0..<result.len:
      for col in 0..<result[0].len:
        graph[row][col] = result[row][col] != 0

    # find nodes that have [i][i] != 0
    var finalNodesIndexes: seq[int]
    for v in 0..<graph.len:
      if graph[v][i]:
        finalNodesIndexes.add v

    var finalPath: seq[int]
    for fni in finalNodesIndexes:
      let path = dfs(graph, i, fni)
      if path.len != 0:
        finalPath = path
        break

    if finalPath.len != 0:
      for ri in finalPath: # ri: row index
        swap result[i], result[ri]

    else:
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
