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
    
    def to_latex(self, max_rows: int = 20, max_cols: int = 20, precision: int = 4) -> str:
        """
        Convert the matrix to LaTeX code for display purposes.
        """
        matrix = self.matrix
        rows = self.rows
        cols = self.cols
        
        if rows > max_rows:
            matrix = matrix[:max_rows//2] + [['...'] * cols] + matrix[-max_rows//2:]
            rows = max_rows
        if cols > max_cols:
            matrix = [row[:max_cols//2] + ['...'] + row[-max_cols//2:] for row in matrix]
            cols = max_cols

        for row in range(rows):
            for col in range(cols):
                if type(matrix[row][col]) is float:
                    matrix[row][col] = round(matrix[row][col], precision)
        
        latex_code = '\\begin{bmatrix}\n'
        for i in range(rows):
            for j in range(cols):
                latex_code += str(matrix[i][j]) + ' & '
            latex_code = latex_code[:-2] + '\\\\ \n'
        latex_code += '\\end{bmatrix}'
        
        return latex_code
    
    def to_typst(self, max_rows: int = 11, max_cols: int = 11, precision: int = 4) -> str:
        """
        Convert the matrix to Typst code for display purposes.
        """
        matrix = self.matrix
        rows = self.rows
        cols = self.cols
        
        if rows > max_rows:
            matrix = matrix[:max_rows//2] + [['dots.v'] * cols] + matrix[-max_rows//2:]
            rows = max_rows
        if cols > max_cols:
            matrix = [row[:max_cols//2] + ['dots.h'] + row[-max_cols//2:] for row in matrix]
            cols = max_cols
        if self.rows > max_rows and self.cols > max_cols:
            matrix[max_rows//2][max_cols//2] = 'dots.down'

        for row in range(rows):
            for col in range(cols):
                if type(matrix[row][col]) is float:
                    matrix[row][col] = round(matrix[row][col], precision)

        typst_code = 'mat('
        for i in range(rows):
            for j in range(cols):
                typst_code += str(matrix[i][j]) + ', ' if j < cols - 1 else str(matrix[i][j])
            typst_code += ';\n'
        typst_code += ')'
        
        return typst_code
    
    @staticmethod
    def new_vector(n: int) -> 'Matrix':
        return Matrix([[0] for _ in range(n)])
    
    @staticmethod
    def from_list(lst: list[int]) -> 'Matrix':
        return Matrix([[element] for element in lst])
    
    @staticmethod
    def new_matrix(rows: int, cols: int, value: int = 0) -> 'Matrix':
        return Matrix([[value for _ in range(cols)] for _ in range(rows)])
