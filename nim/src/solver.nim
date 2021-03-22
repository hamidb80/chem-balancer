import tables, sets, sequtils
import parser

type 
  Matrix[T] = seq[seq[T]]

proc solveLinearAlgebra(A: Matrix[SomeNumber], b: seq[SomeNumber] )=
  doAssert A.len != 0 and A.allIt A.len == it.len, "matrix A must be square"
  doAssert b.len == A.len, "length of b must be equal to rows of A"
  
  # NaCl => Na + Cl
  # [1, -1, 0] [Na]   [0]
  # [1, 0, -1] [Cl] = [0]
  #     A       x   =  b
  

proc eqSolver*(eq: string) =
  let
    parsedEq = equationParser eq
    atoms = atomsSet eq

  var atomCountInEq: Table[string, array[2, seq[int]]]
  for atom in atoms.items:
    atomCountInEq[atom] = [newSeq[int](), newSeq[int]()]
    for i in 0..<2:
      for molecule in parsedEq[i]:
        let num = molecule.getOrDefault(atom, 0)
        atomCountInEq[atom][i].add num

  echo atomCountInEq
  # eq: "NaCl => Na + Cl"
  # atomCountInEq:
  # {
  #   "Cl": [ @[1], @[0, 1] ],
  #   "Na": [ @[1], @[1, 0] ]
  # }


  var matrix: Table[string, seq[int]]
  for atom in atoms.items:
    matrix[atom] = newSeq[int]()
    for (i, coeff) in [(0,1), (1, -1)].items:
      for n in atomCountInEq[atom][i].mapIt(it * coeff):
        matrix[atom].add n

  echo matrix
  # {
  #   "Cl": @[1, 0, -1]
  #   "Na": @[1, -1, 0]
  # }



eqSolver "H2 + O2 => H2O"