from typing import Union, Tuple

class Matrix:
    def __init__(self, matrix: list[list[int]]) -> None:
        """
        Initialize the matrix from 2D list of lists.
        """
        self.matrix = matrix
        self.rows = len(matrix)
        self.cols = len(matrix[0])
    
    def norm(self) -> float:
        """
        Calculate the euclidean norm of the matrix.
        """
        result = 0
        for row in self.matrix:
            for element in row:
                result += element ** 2
        return result ** 0.5
    
    def lu_decomposition(self) -> Tuple['Matrix', 'Matrix']:
        """
        Perform LU decomposition on the matrix.
        """
        n = self.rows
        l = Matrix.new_matrix(n, n)
        u = Matrix.new_matrix(n, n)
        
        for i in range(n):
            for k in range(i, n):
                sum = 0
                for j in range(i):
                    sum += l[i][j] * u[j][k]
                u[i][k] = self[i][k] - sum
        
            for k in range(i, n):
                if i == k:
                    l[i][i] = 1
                else:
                    sum = 0
                    for j in range(i):
                        sum += l[k][j] * u[j][i]
                    l[k][i] = (self[k][i] - sum) / u[i][i]
        
        return l, u
    
    def __getitem__(self, key: int) -> list[int]:
        """
        Get a row of the matrix.
        """
        return self.matrix[key]
    
    def __mul__(self, other: Union[int, 'Matrix']) -> 'Matrix':
        """
        Multiply the matrix by a scalar or another matrix.
        """
        if type(other) == int:
            return Matrix([[other * element for element in row] for row in self.matrix])
        
        if type(other) == Matrix:
            result = Matrix.new_matrix(self.rows, other.cols)
            for i in range(self.rows):
                for j in range(other.cols):
                    result[i][j] = sum([self[i][k] * other[k][j] for k in range(self.cols)])
            return result
        
        raise Exception('Invalid type for multiplication')
    
    def __add__(self, other: 'Matrix') -> 'Matrix':
        """
        Add another matrix to this matrix.
        """
        if self.rows != other.rows or self.cols != other.cols:
            raise Exception('Matrices must have the same dimensions')
        
        return Matrix([[self[i][j] + other[i][j] for j in range(self.cols)] for i in range(self.rows)])
        
    def __sub__(self, other: 'Matrix') -> 'Matrix':
        """
        Subtract another matrix from this matrix.
        """
        if self.rows != other.rows or self.cols != other.cols:
            raise Exception('Matrices must have the same dimensions')
        
        return Matrix([[self[i][j] - other[i][j] for j in range(self.cols)] for i in range(self.rows)])
    
    def to_latex(self) -> str:
        """
        Convert the matrix to LaTeX code for display purposes.
        """
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
        
        return latex_code
    
    @staticmethod
    def new_vector(n: int) -> 'Matrix':
        return Matrix([[0] for _ in range(n)])
    
    @staticmethod
    def new_matrix(rows: int, cols: int, value: int = 0) -> 'Matrix':
        return Matrix([[value for _ in range(cols)] for _ in range(rows)])
