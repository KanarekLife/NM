import numpy as np
from IPython.display import display, Math
from typing import Union, Tuple

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
    
    def norm(self) -> float:
        result = 0
        for row in self.matrix:
            for element in row:
                result += element ** 2
        return result ** 0.5
    
    def __getitem__(self, key: int) -> list[int]:
        return self.matrix[key]
    
    def __mul__(self, other: Union[int, 'Matrix']) -> 'Matrix':
        if type(other) == int:
            return Matrix([[other * element for element in row] for row in self.matrix])
        elif type(other) == Matrix:
            result = Matrix.new_matrix(self.rows, other.cols)
            for i in range(self.rows):
                for j in range(other.cols):
                    result[i][j] = sum([self[i][k] * other[k][j] for k in range(self.cols)])
            return result
        else:
            return NotImplemented
        
    def __sub__(self, other: 'Matrix') -> 'Matrix':
        if self.rows != other.rows or self.cols != other.cols:
            return NotImplemented
        return Matrix([[self[i][j] - other[i][j] for j in range(self.cols)] for i in range(self.rows)])
    
    @staticmethod
    def new_vector(n: int) -> 'Matrix':
        return Matrix([[0] for _ in range(n)])
    
    @staticmethod
    def new_matrix(rows: int, cols: int) -> 'Matrix':
        return Matrix([[0 for _ in range(cols)] for _ in range(rows)])
    
    @staticmethod
    def solve_jacobi(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, verbose: bool = False) -> Tuple['Matrix', int, float]:
        x = Matrix.new_vector(a.rows)
        err = float('inf')
        iterations = 0
        while err > precision:
            x_new = Matrix.new_vector(a.rows)
            for i in range(a.rows):
                x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x[j][0] for j in range(a.rows) if j != i]))
            new_err = ((a * x_new) - b).norm()
            if err < new_err:
                break
            err = new_err
            x = x_new
            iterations += 1
            if verbose:
                print(f'Iteration: {iterations}, Error: {err}')
        return x, iterations, err
    
    @staticmethod
    def solve_gauss_seidel(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, verbose: bool = False) -> Tuple['Matrix', int, float]:
        x = Matrix.new_vector(a.rows)
        err = float('inf')
        iterations = 0
        while err > precision:
            x_new = Matrix.new_vector(a.rows)
            for i in range(a.rows):
                x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x_new[j][0] for j in range(i)]) - sum([a[i][j] * x[j][0] for j in range(i+1, a.rows)]))
            new_err = ((a * x_new) - b).norm()
            if err < new_err:
                break
            err = new_err
            x = x_new
            err = ((a * x) - b).norm()
            iterations += 1
            if verbose:
                print(f'Iteration: {iterations}, Error: {err}')
        return x,iterations, err

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
