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
    
    def get_row(self, row: int) -> List[float]:
        return self.data[row]
    
    def __setitem__(self, row: int, value: Union[List[float], float]) -> None:
        if self.is_vector:
            self.data[row][0] = value
        else:
            self.data[row] = value

    def __mul__(self, other: 'Matrix') -> 'Matrix':
        """
        Returns the product of two matrices.
        """
        if self.cols != other.rows:
            raise ValueError('Number of columns of the first matrix must be equal to the number of rows of the second matrix.')

        n = self.rows
        m = self.cols
        p = other.cols
        result = Matrix.new_square(n)

        for i in range(n):
            for j in range(p):
                for k in range(m):
                    result[i][j] += self[i][k] * other.get_row(k)[j]

        return result
    
    def copy(self) -> 'Matrix':
        """
        Returns a copy of the matrix.
        """
        return Matrix([row.copy() for row in self.data])
    
    def set_diagonal(self, value: float) -> None:
        """
        Sets the diagonal of the matrix to a specific value.
        """
        for i in range(self.rows):
            self.data[i][i] = value

    def pivot(self) -> 'Matrix':
        """
        Returns the matrix with rows pivoted.
        """
        n = self.rows
        m = self.cols
        result = [row.copy() for row in self.data]

        for i in range(n):
            max_row = i
            for j in range(i + 1, n):
                if abs(result[j][i]) > abs(result[max_row][i]):
                    max_row = j
            result[i], result[max_row] = result[max_row], result[i]

        return Matrix(result)
    
    def pivot(U: 'Matrix', L: 'Matrix', P: 'Matrix', i: int) -> None:
        n = U.cols
        max_value = 0
        max_index = i
        for j in range(i, n):
            if abs(U.data[j][i]) > max_value:
                max_value = abs(U.data[j][i])
                max_index = j
        if max_index != i:
            U.data[i], U.data[max_index] = U.data[max_index], U.data[i]
            L.data[i], L.data[max_index] = L.data[max_index], L.data[i]
            P.data[i], P.data[max_index] = P.data[max_index], P.data[i]

    def lu_decomposition(self):
        """
        Returns the LU decomposition of the matrix.
        """
        n = self.rows
        L = Matrix.new_square(n)
        U = self.copy()
        P = Matrix.new_square(n)
        
        L.set_diagonal(1)
        P.set_diagonal(1)

        for i in range(n):
            Matrix.pivot(U, L, P, i)
            for j in range(i+1, n):
                # lower triangular
                L.data[j][i] = U.data[j][i] / U.data[i][i]

                # upper triangular
                for k in range(i, n):
                    U.data[j][k] -= L.data[j][i] * U.data[i][k]

        return L, U, P
    
    def solve(self, b: 'Matrix') -> 'Matrix':
        """
        Solves the linear system Ax = b.
        """
        L, U, P = self.lu_decomposition()
        b = P * b
        
        n = self.rows
        y = Matrix.new_vector(n)
        x = Matrix.new_vector(n)

        for i in range(n):
            y[i] = b[i][0] - sum(L[i][j] * y[j] for j in range(i))

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