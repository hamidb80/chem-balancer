import
  unittest, 
  sets, sequtils
import solver, parser, matrix, number

func `~=`[T](a,b: seq[seq[T]]):bool=
  a.toHashSet == b.toHashSet

func seqseqint2graph(a: seq[seq[int]]): seq[seq[bool]] {.inline.}=
  a.mapIt(it.mapIt it != 0)

func mainDiameterIsNot0(a: Matrix): bool=
  for i in 0..<min(a.len, a[0].len):
    if a[i][i] == 0:
      return false
  true

converter seqint2DToMatrix(a: seq[seq[int]]): Matrix {.inline.}=
  a.toMatrix

suite "dfs":
  test "a path":
    var graph = @[
      @[1,1,1,0],
      @[1,0,0,0],
      @[1,0,0,1],
      @[0,0,1,0],
    ].seqseqint2graph

    let res = dfs(graph, 0, 3)
    check res == @[0,2,3]

  test "no path":
    var graph = @[
      @[1,1,0,0],
      @[1,0,0,0],
      @[1,0,0,1],
      @[0,0,1,0],
    ].seqseqint2graph

    let res = dfs(graph, 0, 3)
    check res.len == 0


suite "specialSort":
  test "m[i][i] is not zero":
    let res = specialSort(@[
      @[0,0,3,0],
      @[0,2,0,3],
      @[1,5,7,3],
    ]) 
    
    check mainDiameterIsNot0 res

  test "remove dupicated & unnecesserrly rows":
    let res = specialSort(@[
        @[1,1,-5,0], 
        @[1,0,0,-1], 
        @[4,0,0,-4], 
        @[0,3,0,-2], 
        @[0,6,-12,0],
        @[0,6,-12,0]
      ])
    
    check:
      res ~= @[
        @[1\1, 1\1, -5\1,  0\1], 
        @[1\1, 0\1,  0\1, -1\1], 
        @[0\1, 1\1,  0\1, -2\3], 
        @[0\1, 1\1, -2\1,  0\1]
      ]
      mainDiameterIsNot0 res
      res.len == 4

  test "order (1":
    let res = specialSort(@[
      @[1,  0, 2, 0],
      @[1, -5, 7, 0],
      @[0,  0, 1, 1],
      @[1, -1, 0, 0]
    ])
    
    check mainDiameterIsNot0 res

  test "order (2":
    let res =  specialSort(@[
      @[1, 1,  0, -2,  0],
      @[1, 1, -1,  0,  0],
      @[0, 0,  1,  0, -2],
      @[0, 1,  0,  0,  4]
    ]) 
    
    check mainDiameterIsNot0 res
    

suite "extract coeff matrix":
  test "FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4":
    {.cast(gcsafe).}:
      let parsedEq = equationParser("FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4")
      check createCoeffMatrixFromEq(parsedEq) ~= @[
        @[1,1, -5,  0],  # Fe
        @[1,0,  0, -1],  # S
        @[4,0,  0, -4],  # O
        @[0,3,  0, -2],  # K
        @[0,6, -12, 0], # N
        @[0,6, -12, 0]  # C
      ]

suite "equation balancer":
  test "O2 => O3":
    check eqSolver("O2 => O3") == @[3 ,2]

  test "O2 + H2 => H2O":
    check eqSolver("O2 + H2 => H2O") == @[1, 2, 2]

  test "(NH4)2(HO)2 => NH4 + HO":
    check eqSolver("(NH4)2(HO)2 => NH4 + HO") == @[1 ,2 ,2]

  test "Al + Fe2O3 => Fe + Al2O3":
    check eqSolver("Al + Fe2O3 => Fe + Al2O3") == @[2, 1, 2, 1]

  test "FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4":
    check eqSolver("FeSO4 + K3(FeC6N6) => Fe3(FeC6N6)2 + K2SO4") == @[3, 2 ,1 ,3]

  test "K4Fe(SCN)6 + K2Cr2O7 + H2SO4 => Fe2(SO4)3 + Cr2(SO4)3 + CO2 + H2O + K2SO4 + KNO3":
    check eqSolver("K4Fe(SCN)6 + K2Cr2O7 + H2SO4 => Fe2(SO4)3 + Cr2(SO4)3 + CO2 + H2O + K2SO4 + KNO3") == @[6, 97 ,355 ,3, 97, 36, 355, 91, 36]
  
  test "CaCl2 => Ca+2 + Cl-":
    check eqSolver("CaCl2 => Ca+2 + Cl-") == @[1, 1, 2]

  test "I- + IO3- + H+ => I2 + H2O":
    check eqSolver("I- + IO3- + H+ => I2 + H2O") == @[5,  1, 6, 3 ,3]

# TODO add test for wrong eqs
  # add more tests
  # "A + B => C + D"
  # 'I cant balance it!'