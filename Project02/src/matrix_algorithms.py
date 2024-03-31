from dataclasses import dataclass
from matrix import Matrix
from typing import Tuple
import time

@dataclass
class LUResult:
    def __init__(self, result: 'Matrix', error: float, took: float) -> None:
        self.result = result
        self.error = error
        self.took = took

@dataclass
class IterativeMethodResult:
    def __init__(self, result: 'Matrix', iterations: int, errors: list[float], did_finish: bool, took: float) -> None:
        self.result = result
        self.iterations = iterations
        self.errors = errors
        self.did_finish = did_finish
        self.took = took
    
    def best(self) -> Tuple[int, float]:
        return min(enumerate(self.errors), key=lambda x: x[1])

def solve_jacobi(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, max_error = 1e9, verbose: bool = False) -> IterativeMethodResult:
    """
    Solve the system of linear equations Ax = b using the Jacobi method.
    """
    x = Matrix.new_vector(a.rows)
    err = [float('inf')]
    iterations = 0
    does_converge = True
    start = time.perf_counter()
    while err[-1] > precision:
        x_new = Matrix.new_vector(a.rows)
        for i in range(a.rows):
            x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x[j][0] for j in range(a.rows) if j != i]))
        new_err = ((a * x_new) - b).norm()
        if max_error < new_err:
            does_converge = False
            break
        err.append(new_err)
        x = x_new
        iterations += 1
        if verbose:
            print(f'Iteration: {iterations}, Error: {err[-1]}')
    end = time.perf_counter()
    return IterativeMethodResult(x, iterations, err, does_converge, end - start)
    
def solve_gauss_seidel(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, max_error = 1e9, verbose: bool = False) -> IterativeMethodResult:
    """
    Solve the system of linear equations Ax = b using the Gauss-Seidel method.
    """
    x = Matrix.new_vector(a.rows)
    err = [float('inf')]
    iterations = 0
    does_converge = True
    start = time.perf_counter()
    while err[-1] > precision:
        x_new = Matrix.new_vector(a.rows)
        for i in range(a.rows):
            x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x_new[j][0] for j in range(i)]) - sum([a[i][j] * x[j][0] for j in range(i+1, a.rows)]))
        new_err = ((a * x_new) - b).norm()
        if max_error < new_err:
            does_converge = False
            break
        err.append(new_err)
        x = x_new
        iterations += 1
        if verbose:
            print(f'Iteration: {iterations}, Error: {err[-1]}')
    end = time.perf_counter()
    return IterativeMethodResult(x, iterations, err, does_converge, end-start)

def solve_lu(a: 'Matrix', b: 'Matrix') -> LUResult:
    """
    Solve the system of linear equations Ax = b using LU decomposition.
    """
    start = time.perf_counter()
    l, u = a.lu_decomposition()
    y = Matrix.new_vector(a.rows)
    x = Matrix.new_vector(a.rows)
    
    for i in range(a.rows):
        y[i][0] = b[i][0] - sum([l[i][j] * y[j][0] for j in range(i)])
    
    for i in range(a.rows-1, -1, -1):
        x[i][0] = (1/u[i][i]) * (y[i][0] - sum([u[i][j] * x[j][0] for j in range(i+1, a.rows)]))
    end = time.perf_counter()
    return LUResult(x, ((a * x) - b).norm(), end-start)