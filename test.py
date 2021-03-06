import pytest
from app import Balancer

inputs = [
    "H2 + O2 => H2O",
    "Br2 + H2 => BrH",
    "C5H12 + O2 => CO2 + H2O",
    "Al + Fe2O3 => Al2O3 + Fe",
    "O2 => O3",

    "Fe2(SO4)3 => Fe + SO4",
    "(NH4)2(HO)2 => NH4 + HO",

    "FeSO4 + K3(Fe(CN)6) => Fe3(Fe(CN)6)2 + K2SO4",

    "A + B => C + D"
]
expected_outs = [
    "2H2 + O2 => 2H2O",
    "Br2 + H2 => 2BrH",
    "C5H12 + 8O2 => 5CO2 + 6H2O",
    "2Al + Fe2O3 => Al2O3 + 2Fe",
    "3O2 => 2O3",

    "Fe2(SO4)3 => 2Fe + 3SO4",
    "(NH4)2(HO)2 => 2NH4 + 2HO",

    "3FeSO4 + 2K3(Fe(CN)6) => Fe3(Fe(CN)6)2 + 3K2SO4",

    'I cant balance it!'
]


def test_integrate():
    outs = []

    for inp in inputs:
        res = Balancer(inp).balance()
        outs.append(res)

    assert outs == expected_outs


if __name__ == "__main__":
    test_integrate()
