import re

class Balancer:
    def __init__(self, react_formula):
        self.max_k = 50

        self.k = []
        # splitter index for k var
        self.splitter_i = 0

        self.react = react_formula.replace('+', ' ').split('=>')
        self.dic_react = []

        self.atoms_set = set()

        self.is_done = False
        self.answer = ''

    def balance(self):
        self.react = [side.split() for side in self.react]

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

        res = self.looper()
        return res

    def looper(self, n=0):
        for i in range(self.max_k):
            if n != len(self.k) - 1:
                self.looper(n + 1)

            else:
                if self.check_valid():
                    self.answer = self.get_answer()
                    return self.answer

            self.k[n] += 1

            if self.answer:
                return self.answer

        self.k[n] = 1

    def check_valid(self):
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
