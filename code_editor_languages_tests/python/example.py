from sys import path


def hello() -> int:
    print(path)
    print("hello")
    return 1


# buen días
def hola(name: str) -> int:
    print(name)
    return 0


a = [-6, 1, 4, 4, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

if __name__ == "__main__":
    hello()
    hola("Mario")
