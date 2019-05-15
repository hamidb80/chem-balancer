import pytest
from app import Balancer

inps = [
    "H2 + O2 => H2O",
    "Br2 + H2 => BrH",
    "C5H12 + O2 => CO2 + H2O",
    "Al + Fe2O3 => Al2O3 + Fe",
    "O2 => O3"
]
expected_outs = [
    "2H2 + O2 => 2H2O",
    "Br2 + H2 => 2BrH",
    "C5H12 + 8O2 => 5CO2 + 6H2O",
    "2Al + Fe2O3 => Al2O3 + 2Fe",
    "3O2 => 2O3"
]


def test_unit():
    outs = []

    for inp in inps:
        res = Balancer(inp).balance()
        outs.append(res)

    assert outs == expected_outs



if __name__ == "__main__":
    test_unit()
