import
  strformat,
  strutils,
  sequtils
import number

type
  List* = seq[SNumber]
  Matrix* = seq[List]

# ------------ converts ---------------------

func toMatrix*(m: seq[seq[int]]): Matrix =
  for y in 0..<m.len:
    result.add newSeq[SNumber]()
    for x in 0..<m[y].len:
      result[^1].add initSNumber m[y][x]

func toList*(s: seq[int]): List =
  for i in 0..<s.len:
    result.add initSNumber s[i]

func `$`*(m: Matrix): string =
  for row in m:
    let s = row.join ", "
    result.add &"[{s}]\n"

# ------------ functionalities ---------------------

func `==`*(m1, m2: Matrix): bool =
  if m1.len != m2.len or m1[0].len != m2[0].len:
    return false

  for y in 0..<m1.len:
    for x in 0..<m1[0].len:
      if m1[y][x] != m2[y][x]:
        return false
  true

func transpose*(m: Matrix): Matrix =
  result = newSeqWith(m[0].len, newSeqWith(m.len, 0\1))
  for i in 0..<m.len:
    for j in 0..<m[0].len:
      result[i][j] = m[j][i]

proc guassianSolveLinearAlgebra*(A: Matrix, b: List): List =
  ## solve n eq n unknowns with guassian method
  if A.len == 1:
    return
      if A[0][0] == 0: @[b[0]]
      else: @[b[0] / A[0][0]]

  var
    M = A
    newb = b

  for y in 1..<M.len: # make top triangle matrix
    let answers = guassianSolveLinearAlgebra(
      transpose M[0..<y].mapIt it[0..<y],
      M[y][0..<y])

    for i in 0..<answers.len:
      let k = answers[^(i+1)]
      for x in 0..<M[y].len:
        M[y][x] -= k * M[y - (i + 1)][x]
      newb[y] -= k * newb[y - (i + 1)]

  for d in 0..<M.len: # making the main diameter 1
    let k = M[d][d]
    if k == 0: continue

    for x in 0..<M[d].len:
      M[d][x] /= k
    newb[d] /= k

  for y in countdown(M.len - 1, 0): # knowns
    let others = M[y][y+1..<M[y].len]
    var ansCell = newb[y]

    for k in 0..<result.len:
      ansCell -= others[k] * result[k]
    result.insert ansCell, 0
