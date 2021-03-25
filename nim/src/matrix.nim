import 
  strformat,
  strutils,
  sequtils
import number

# import random
# randomize()

type 
  List* = seq[SNumber]
  Matrix* = seq[List]

func `$`*(m: Matrix): string=
  for row in m:
    let s = row.join ", "
    result.add &"[{s}]\n"

func toMatrix*(m: seq[seq[int]]): Matrix=
  for y in 0..<m.len:
    result.add newSeq[SNumber]()
    for x in 0..<m[y].len:
      result[^1].add initSNumber m[y][x]

func toList*(s: seq[int]): List=
  for i in 0..<s.len:
    result.add initSNumber s[i]

func `==`*(m1,m2: Matrix): bool=
  if m1.len != m2.len or m1[0].len != m2[0].len:
    return false
  
  for y in 0..<m1.len:
    for x in 0..<m1[0].len:
      if m1[y][x] != m2[y][x]:
        return false
  true

func specialSort*(s: Matrix): Matrix=
  ## sort by matrix[i][i] is not 0
  
  # FIXME: in some special cases needs deeper check
  # 1. check for duplicated row 
  var m = s

  for i in 0..<s.len:
    for row_i in 0..<m.len:
      if i >= m[row_i].len or m[row_i][i] != 0:
        result.add m[row_i]
        m.del row_i
        break

proc guassianSolveLinearAlgebra*(A: Matrix, b: List, isSorted = false): List=
  # let id = rand 0..100
  ## solve n eq n unknowns with guassian method
  if A.len == 1:
    return
      if b[0] == 0: @[b[0]]
      else: @[b[0] / A[0][0]]

  var M = A # sort rows by the number of first zeroes

  for y in 0..<M.len:
    M[y].add b[y] # add answer column
  
  if isSorted == false:
    M = specialSort M
  
  var newb: List
  for y in 0..<M.len: # extract sorted b(= new b) from M matrix 
    newb.add M[y].pop

  for y in 1..<M.len: # make up triangle matrix 
    let answers = guassianSolveLinearAlgebra(
      M[0..<y].mapIt it[0..<y],
      M[y][0..<y],
      true)

    for i in 0..<answers.len:
      for x in 0..<M[y].len:
        M[y][x] -= answers[^(i+1)] * M[y - (i + 1)][x]
  
  for d in 0..<M.len: # making the main diameter 1
    let k = M[d][d]
    for x in 0..<M[d].len:
      M[d][x] /= k
    newb[d] /= k

  # TODO: check is it possible to solve this or not

  for y in countdown(M.len - 1, 0): # knowns or vars : result
    let others = M[y][y+1..<M[y].len]
    var sum = newb[y]
    
    for k in 0..<result.len:
      sum -= others[k] * result[k]
    result.insert sum, 0