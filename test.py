ls = [1, 1, 1]
max_k = 2


def looper(n=0):

    for i in range(max_k + 1):
        if n != len(ls) - 1:
            looper(n + 1)

        else:
            print(ls)

        ls[n] += 1

    ls[n] = 1

looper()
