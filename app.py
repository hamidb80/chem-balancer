import functools
import re

max_k = 50
k = []
splitter_i = 0
dic_react = []
react = []
all_atoms = set()
is_done = False


def main():
    global splitter_i, k, all_atoms, react

    inp = input("enter your react: (A => B)\n").split('=>')
    # inp = "H2 + O2 => H2O"
    # inp = "C5H12 + O2 => CO2 + H2O"
    # inp = "Al + Fe2O3 => Al2O3 + Fe"
    # inp = "N2 + H2 => NH3"

    react = inp.replace('+', ' ').split('=>')

    if len(react) != 2:
        print("error: the pattern should match with (A => B)")

    react = [s.split() for s in react]
    # all_atoms = set()

    # dic_react = []

    for side in react:
        molecules = []
        for molecule in side:

            atoms = re.findall(r'[A-Z][a-z]?[0-9]*', molecule)

            atoms_dic = {}

            for atom in atoms:
                name = re.search(r'[A-Z][a-z]?', atom)[0]

                all_atoms.add(name)

                number = re.search(r'[0-9]+', atom)
                number = int(number[0]) if number else 1

                atoms_dic[name] = number

            molecules.append(atoms_dic)

        # print(molecules)

        dic_react.append(molecules)

    # print(react)
    print(dic_react)
    print(all_atoms)

    # init k
    k = [1] * len(react[0] + react[1])

    # print(k, ' --')

    splitter_i = len(react[0])

    looper()


def looper(n=0):
    global max_k, k, splitter_i, is_done

    for i in range(max_k):
        if n != len(k) - 1:
            looper(n + 1)

        else:
            # print(k)

            if is_balanced():
                is_done = True
                ans = answer(k)

                print(ans)
                return

        k[n] += 1

        if is_done:
            return

    k[n] = 1



def is_balanced():
    global k, splitter_i, dic_react, all_atoms
    splitted_k = [k[:splitter_i], k[splitter_i:]]

    for atom in all_atoms:
        res = [0, 0]

        for side_i in range(len(dic_react)):
            for molecule_i, molecule in enumerate(dic_react[side_i]):

                atom_number = molecule.get(atom)
                if atom_number:
                    res[side_i] += atom_number * splitted_k[side_i][molecule_i]

        if res[0] != res[1]:
            return False

    return True


def answer(correct_k):
    global react, splitter_i, k
    splitted_k = [k[:splitter_i], k[splitter_i:]]

    formula = [[], []]

    for side_i, side in enumerate(react):

        for molecule_i, molecule in enumerate(side):

            current_k = splitted_k[side_i][molecule_i]

            if current_k == 1:
                current_k = ''

            formula[side_i].append(f'{current_k}{molecule}')

        formula[side_i] = ' + '.join(formula[side_i])

    return ' => '.join(formula)


if __name__ == "__main__":
    main()
