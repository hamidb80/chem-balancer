import solver

if isMainModule:

  echo "~~::Chemical Equation Balancer::~~"
  echo "enter the equation like this: H2 + O2 => H2O"

  let eq = stdin.readLine

  eqSolver eq
