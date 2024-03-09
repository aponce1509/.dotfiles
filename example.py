import os
import typing
import sys


def hello() -> None:
    print(sys.path)
    print("hello")
    return None


def hola() -> str:
    return "Hola"


a = [-6, 1, 4, 4, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

if __name__ == "__main__":
    hello()
