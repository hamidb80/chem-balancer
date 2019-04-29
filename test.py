import pytest
import app

inps = [
    "H2 + O2 => H2O",
    "Br2 + H2 => BrH",
    "C5H12 + O2 => CO2 + H2O",
    "Al + Fe2O3 => Al2O3 + Fe",
]
outs = []
expected_outs = [
    "2H2 + O2 => 2H2O",
    "Br2 + H2 => 2BrH",
    "C5H12 + 8O2 => 5CO2 + 6H2O",
    "2Al + Fe2O3 => Al2O3 + 2Fe",
]


def virtual_input(txt=''):
    return inps.pop()


def virtual_print(out):
    print(out, '--')
    return outs.append(out)


app.input = virtual_input
app.print = virtual_print


def test_unit():
    for i in inps:
        print(i)
        app.main()

    assert outs == expected_outs



if __name__ == "__main__":
    test_unit()
