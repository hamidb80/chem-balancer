import re
from collections import defaultdict

from typing import List, Dict
from string import digits

"""
in all the project:
    'k' means 'coefficient'
"""


class Balancer:
    def __init__(self, react_formula: str, max_k=20):
        self.max_k = max_k

        self.k = []
        # splitter index for k var
        self.splitter_i = None

        self.original_react = self.init_react_formula(react_formula)
        self.custom_react = self.init_custom_react()

        self.atoms_set = {
            *[atom for atom in re.findall(r"[A-Z][a-z]?", react_formula)]
        }

    # According to the react, the k array splits
    @property
    def splitted_k(self):
        return [self.k[:self.splitter_i], self.k[self.splitter_i:]]

    # checks these items:
    # - the react formula should have '=>'
    # - invalid character checking
    def validate(self, react_formula: str):
        if '=>' not in react_formula:
            return False

        molecules = react_formula.replace('+', '').replace('=>', '').split()

        for molecule in molecules:
            # check there is no invalid characters
            molecule_match = re.match(r'([[A-Za-z0-9()])+$', molecule)

            if molecule_match[0] != molecule:
                return False

        return True

    # converts "H2 + O2 => H2O" to [['H2', 'O2'], ['H2O']]
    def init_react_formula(self, react_formula: str) -> List[List[str]]:
        validation = self.validate(react_formula)

        if not validation:
            raise Exception("[Syntax Error]: the react formula is not correct")

        react = react_formula.replace('+', ' ').split('=>')
        react = [side.split() for side in react]

        return react

    # convert string molecules to dict in react_dict : H2O -> {H:2, O:1}
    def init_custom_react(self) -> List[List[Dict[str, int]]]:
        res = []

        for side in self.original_react:
            molecules = []

            molecule: str
            for molecule in side:
                molecule_dict = self.molecule_to_dict(molecule)
                molecules.append(molecule_dict)

            res.append(molecules)

        return res

    def molecule_to_dict(self, molecule: str, k=1) -> dict:
        res = defaultdict(int)

        sub_molecules_str = self.sepertate_molecule(molecule)

        for sub_molecule_str in sub_molecules_str:
            if '(' in sub_molecule_str:

                last_close_par_i = sub_molecule_str.rfind(')')

                molecule_str = sub_molecule_str[1:last_close_par_i]
                molecule_k = sub_molecule_str[last_close_par_i + 1:] or '1'

                atoms = self.molecule_to_dict(
                    molecule_str, int(molecule_k) * k)

                for atom, atom_k in atoms.items():
                    res[atom] += atom_k

            else:
                atoms = re.findall(r"([A-Z][a-z]?)([0-9]*)", sub_molecule_str)

                for atom_str, atom_k in atoms:
                    atom_k = 1 if atom_k == '' else int(atom_k)

                    res[atom_str] += atom_k * k

        return res

    def sepertate_molecule(self, molecule: str) -> List[str]:
        res = []

        open_par_i = -1
        close_par_i = -2
        pars_to_close = 0
        last_pos = -1

        for char_i, char in enumerate(molecule):
            if char == '(':

                if open_par_i == -1:

                    if last_pos != char_i - 1:
                        res.append(molecule[last_pos + 1:char_i])
                        last_pos = char_i

                    open_par_i = char_i

                else:
                    pars_to_close += 1

            elif char == ')':

                if pars_to_close == 0:
                    res.append(molecule[open_par_i: char_i + 1])
                    open_par_i = -1
                    last_pos = char_i

                    close_par_i = char_i

                else:
                    pars_to_close -= 1

            elif char_i - 1 == close_par_i:
                if char in digits:
                    res[-1] += char
                    close_par_i = char_i

            elif char_i == len(molecule) - 1:
                res.append(molecule[last_pos + 1:])

        return res

    def balance(self):
        # init k
        self.k = [1] * len(self.original_react[0] + self.original_react[1])
        self.splitter_i = len(self.original_react[0])

        res = self.looper()
        return self.get_answer() if res else 'I cant balance it!'

    def looper(self, n=0):
        for _ in range(self.max_k):
            if n != len(self.k) - 1:
                res = self.looper(n + 1)

                if res:
                    return True

            elif self.is_balanced():
                return True

            self.k[n] += 1

        self.k[n] = 1

    def is_balanced(self) -> bool:
        splitted_k = self.splitted_k

        for atom in self.atoms_set:
            res = [0, 0]

            for side_i in range(len(self.custom_react)):
                for molecule_i, molecule in enumerate(self.custom_react[side_i]):

                    atom_number = molecule.get(atom)
                    if atom_number:
                        res[side_i] += atom_number * \
                            splitted_k[side_i][molecule_i]

            if res[0] != res[1]:
                return False

        return True

    def get_answer(self) -> str:
        splitted_k = self.splitted_k

        formula = [[], []]

        for side_i, side in enumerate(self.original_react):
            for molecule_i, molecule in enumerate(side):

                current_k = splitted_k[side_i][molecule_i]

                if current_k == 1:
                    current_k = ''

                formula[side_i].append(f'{current_k}{molecule}')

            formula[side_i] = ' + '.join(formula[side_i])

        return ' => '.join(formula)


def main():
    inp = input("enter your react: (Br2 + H2 => BrH)\n")

    res = Balancer(inp).balance()
    print(res)


if __name__ == "__main__":
    main()
