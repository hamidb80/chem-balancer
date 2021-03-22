import tables, sets
import parser

type 
  Matrix[T] = seq[seq[T]]

proc solveLinearAlgebra(A, b: Matrix[SomeNumber] )=
  # [1, 2, 3] [x1]   [1]
  # [1, 2, 3] [x2] = [2]
  # [1, 2, 3] [x3]   [3]
  #     A      x   =  b
  
  echo "jel"

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
  #   "Na": [ @[1], @[0, 1] ]
  # }



eqSolver "H2 + O2 => H2O"