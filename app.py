import re
from termcolor import cprint


class Balancer:
    def __init__(self, react_formula: str):
        self.max_k = 50

        self.k = []
        # splitter index for k var
        self.splitter_i = 0

        self.react = self.init_react(react_formula)
        self.dic_react = []

        self.atoms_set = set()

        self.is_done = False
        self.answer = ''

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

    def init_react(self, react_formula: str):
        validation = self.react_formula_validation(react_formula)

        if not validation:
            cprint("[Syntax Error]: the react formula is not correct",
                   'white', 'on_red')
            return

        react = react_formula.replace('+', ' ').split('=>')
        react = [side.split() for side in react]

        return react

    def balance(self):

        # convert string molecules to dict in dic_react : H2O -> {H:2, O:1}
        for side in self.react:
            molecules = []

            for molecule in side:
                atoms = re.findall(r'[A-Z][a-z]?[0-9]*', molecule)
                atoms_dic = {}

                for atom in atoms:
                    name = re.search(r'[A-Z][a-z]?', atom)[0]

                    self.atoms_set.add(name)

                    number = re.search(r'[0-9]+', atom)
                    number = int(number[0]) if number else 1

                    atoms_dic[name] = number

                molecules.append(atoms_dic)

            self.dic_react.append(molecules)

        # init k
        self.k = [1] * len(self.react[0] + self.react[1])
        self.splitter_i = len(self.react[0])

        self.looper()
        return self.answer

    def looper(self, n=0):
        for i in range(self.max_k):
            if n != len(self.k) - 1:
                self.looper(n + 1)

            else:
                if self.is_balanced():
                    self.answer = self.get_answer()

            if self.answer:
                return

            self.k[n] += 1

        self.k[n] = 1

    def is_balanced(self):
        splitted_k = [self.k[:self.splitter_i], self.k[self.splitter_i:]]

        for atom in self.atoms_set:
            res = [0, 0]

            for side_i in range(len(self.dic_react)):
                for molecule_i, molecule in enumerate(self.dic_react[side_i]):

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

        for side_i, side in enumerate(self.react):
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
