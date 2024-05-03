from typing import List, Tuple, Union

class Matrix:
    def __init__(self, data: List[List[float]]) -> None:
        self.data = data
        self.rows = len(data)
        self.cols = len(data[0])
        self.is_vector = self.cols == 1

    def __getitem__(self, row: int) -> Union[List[float], float]:
        row = self.data[row]

        if self.is_vector:
            return row[0]

        return row
    
    def __setitem__(self, row: int, value: Union[List[float], float]) -> None:
        if self.is_vector:
            self.data[row][0] = value
        else:
            self.data[row] = value

    def lu_decomposition(self):
        """
        Returns the LU decomposition of the matrix.
        """
        n = self.rows
        L = Matrix.new_square(n)
        U = Matrix.new_square(n)

        for i in range(n):
            L[i][i] = 1.0

        for i in range(n):
            for j in range(i, n):
                U[i][j] = self[i][j] - sum(L[i][k] * U[k][j] for k in range(i))
            for j in range(i + 1, n):
                L[j][i] = (self[j][i] - sum(L[j][k] * U[k][i] for k in range(i))) / U[i][i]

        return L, U
    
    def solve(self, b: 'Matrix') -> 'Matrix':
        """
        Solves the linear system Ax = b.
        """
        L, U = self.lu_decomposition()
        n = self.rows
        y = Matrix.new_vector(n)
        x = Matrix.new_vector(n)

        for i in range(n):
            y[i] = b[i] - sum(L[i][j] * y[j] for j in range(i))

        for i in range(n - 1, -1, -1):
            x[i] = (y[i] - sum(U[i][j] * x[j] for j in range(i + 1, n))) / U[i][i]

        return x
    
    def to_flat_list(self) -> Union[List[float]]:
        """
        Returns the matrix as a list of lists or list when matrix is a vector.
        """
        if self.is_vector:
            return [self[i] for i in range(self.rows)]
        
        result = []
        for i in range(self.rows):
            result.extend(self[i])
        return result
    
    @staticmethod
    def new_square(n: int, default_value: float = 0.0) -> 'Matrix':
        """
        Returns a new square matrix of size n x n.
        """
        return Matrix([[default_value] * n for _ in range(n)])
    
    @staticmethod
    def new_vector(n: int, default_value: float = 0.0) -> 'Matrix':
        """
        Returns a new vector matrix of size n x 1.
        """
        return Matrix([[default_value] for _ in range(n)])