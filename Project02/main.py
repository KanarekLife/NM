import numpy as np
from IPython.display import display, Math

class Matrix:
    def __init__(self, matrix: list[list[int]]) -> None:
        self.matrix = matrix
        self.rows = len(matrix)
        self.cols = len(matrix[0])

    def print(self) -> None:
        matrix = self.matrix
        rows = self.rows
        cols = self.cols
        
        if rows > 20:
            matrix = matrix[:10] + [['...'] * cols] + matrix[-10:]
            rows = 20
        if cols > 20:
            matrix = [row[:10] + ['...'] + row[-10:] for row in matrix]
            cols = 20
        
        latex_code = '\\begin{bmatrix}\n'
        for i in range(rows):
            for j in range(cols):
                latex_code += str(matrix[i][j]) + ' & '
            latex_code = latex_code[:-2] + '\\\\ \n'
        latex_code += '\\end{bmatrix}'
        
        return display(Math(latex_code))
    
    def __getitem__(self, key: int) -> list[int]:
        return self.matrix[key]
    
    def __rmul__(self, other: int) -> 'Matrix':
        if type(other) == int:
            return Matrix([[other * element for element in row] for row in self.matrix])
        else:
            return NotImplemented
    
    @staticmethod
    def new_vector(n: int) -> 'Matrix':
        return Matrix([[0] for _ in range(n)])
    
    @staticmethod
    def norm(a: 'Matrix', b: 'Matrix', x: 'Matrix') -> 'Matrix':
        return NotImplemented
    
    @staticmethod
    def solve_jacobi(a: 'Matrix', b: 'Matrix', iterations: int) -> 'Matrix':
        x = Matrix.new_vector(a.rows)
        for _ in range(iterations):
            x_new = Matrix.new_vector(a.rows)
            for i in range(a.rows):
                x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x[j][0] for j in range(a.rows) if j != i]))
            x = x_new
        return x
    
    @staticmethod
    def solve_gauss_seidel(a: 'Matrix', b: 'Matrix', iterations: int) -> 'Matrix':
        x = Matrix.new_vector(a.rows)
        for _ in range(iterations):
            x_new = Matrix.new_vector(a.rows)
            for i in range(a.rows):
                x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x_new[j][0] for j in range(i)]) - sum([a[i][j] * x[j][0] for j in range(i+1, a.rows)]))
            x = x_new
        return x

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
        matrix.append([np.sin(i * f)])
    return Matrix(matrix)

# index_number = 193044
# n = 900 + 10 * (index_number % 100 // 10) + (index_number % 10)
# a = get_A(n, 5 + index_number % 1000 // 100, -1, -1)
# a.print()
# b = get_B(n, (index_number % 10000 // 1000) + 1)
# b.print()
