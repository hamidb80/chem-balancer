import macros, algorithm

macro switchableArgs*(body: untyped): untyped =
  doAssert body.kind == nnkFuncDef or body.kind == nnkProcDef

  var bodyCopy = copy body
  var args = bodyCopy.findChild it.kind == nnkFormalParams
  let startIndex =
    if args[0].kind == nnkIdentDefs: 0
    else: 1

  let ua = args[startIndex..startIndex+1]
  args.del startIndex, 2
  args.add reversed ua

  # echo treeRepr newStmtList(body, bodyCopy)
  newStmtList(body, bodyCopy)