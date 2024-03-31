from matrix import Matrix
from numpy import sin
from IPython.display import display, Math

def get_A(n: int, a1: int, a2: int, a3: int) -> Matrix:
    matrix = []
    for i in range(n):
        row = []
        for j in range(n):
            if i == j:
                row.append(a1)
            elif abs(i-j) == 1:
                row.append(a2)
            elif abs(i-j) == 2:
                row.append(a3)
            else:
                row.append(0)
        matrix.append(row)
    return Matrix(matrix)

def get_B(n: int, f: int) -> Matrix:
    matrix = []
    for i in range(1, n+1):
        matrix.append([float(sin(i * f))])
    return Matrix(matrix)

def display_math(latex: str) -> None:
    display(Math(latex))