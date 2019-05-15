import re
from termcolor import cprint


class Balancer:
    def __init__(self, react_formula: str, max_k=50):
        self.max_k = max_k

        self.k = []
        # splitter index for k var
        self.splitter_i = None

        self.original_react = self.init_react_formula(react_formula)
        self.custom_react = []

        self.atoms_set = set()

    def react_formula_validation(self, react_formula: str):
        if '=>' not in react_formula:
            return False

        molecules = react_formula.replace('+', '').replace('=>', '').split()

        for molecule in molecules:
            # check there is no invalid characters
            m_match = re.match(r'([[A-Za-z0-9])+', molecule)

            if m_match[0] != molecule:
                return False

            # check all sub k in molecules not equal to 0
            sub_k_list = re.findall(r"[A-Z][a-z]?([0-9]+)", molecule)
            for sub_k in sub_k_list:
                if int(sub_k) == 0:
                    return False

        return True

    def init_react_formula(self, react_formula: str):
        validation = self.react_formula_validation(react_formula)

        if not validation:
            cprint("[Syntax Error]: the react formula is not correct",
                   'white', 'on_red')
            return 'Error'

        react = react_formula.replace('+', ' ').split('=>')
        react = [side.split() for side in react]

        return react

    def init_react_dict(self):

        # convert string molecules to dict in react_dict : H2O -> {H:2, O:1}
        for side in self.original_react:
            molecules = []

            for molecule in side:
                molecule_dict = {}
                atoms = re.findall(r'[A-Z][a-z]?[0-9]*', molecule)

                for atom in atoms:
                    name = re.search(r'[A-Z][a-z]?', atom)[0]

                    self.atoms_set.add(name)

                    number = re.search(r'[0-9]+', atom)
                    number = int(number[0]) if number else 1

                    molecule_dict[name] = number

                molecules.append(molecule_dict)

            self.custom_react.append(molecules)

    def balance(self):
        self.init_react_dict()

        # init k
        self.k = [1] * len(self.original_react[0] + self.original_react[1])
        self.splitter_i = len(self.original_react[0])

        res = self.looper()
        return self.get_answer() if res else 'I cant balance it!'

    def looper(self, n=0):
        for i in range(self.max_k):
            if n != len(self.k) - 1:
                res = self.looper(n + 1)

                if res:
                    return True

            elif self.is_balanced():
                return True

            self.k[n] += 1

        self.k[n] = 1

    def is_balanced(self):
        splitted_k = [self.k[:self.splitter_i], self.k[self.splitter_i:]]

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

    def get_answer(self):
        splitted_k = [self.k[:self.splitter_i], self.k[self.splitter_i:]]

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
