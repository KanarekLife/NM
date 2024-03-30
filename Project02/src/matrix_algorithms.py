from typing import Tuple
from matrix import Matrix

def solve_jacobi(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, verbose: bool = False) -> Tuple['Matrix', int, list[float], bool]:
    """
    Solve the system of linear equations Ax = b using the Jacobi method.
    """
    x = Matrix.new_vector(a.rows)
    err = [float('inf')]
    iterations = 0
    does_converge = True
    while err[-1] > precision:
        x_new = Matrix.new_vector(a.rows)
        for i in range(a.rows):
            x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x[j][0] for j in range(a.rows) if j != i]))
        new_err = ((a * x_new) - b).norm()
        if err[-1] < new_err:
            does_converge = False
            break
        err.append(new_err)
        x = x_new
        iterations += 1
        if verbose:
            print(f'Iteration: {iterations}, Error: {err[-1]}')
    return x, iterations, err, does_converge
    
def solve_gauss_seidel(a: 'Matrix', b: 'Matrix', precision: float = 1e-9, verbose: bool = False) -> Tuple['Matrix', int, list[float], bool]:
    """
    Solve the system of linear equations Ax = b using the Gauss-Seidel method.
    """
    x = Matrix.new_vector(a.rows)
    err = [float('inf')]
    iterations = 0
    does_converge = True
    while err[-1] > precision:
        x_new = Matrix.new_vector(a.rows)
        for i in range(a.rows):
            x_new[i][0] = (1/a[i][i]) * (b[i][0] - sum([a[i][j] * x_new[j][0] for j in range(i)]) - sum([a[i][j] * x[j][0] for j in range(i+1, a.rows)]))
        new_err = ((a * x_new) - b).norm()
        if err[-1] < new_err:
            does_converge = False
            break
        err.append(new_err)
        x = x_new
        iterations += 1
        if verbose:
            print(f'Iteration: {iterations}, Error: {err[-1]}')
    return x, iterations, err, does_converge

def solve_lu(a: 'Matrix', b: 'Matrix') -> Tuple['Matrix', int]:
    """
    Solve the system of linear equations Ax = b using LU decomposition.
    """
    l, u = a.lu_decomposition()
    y = Matrix.new_vector(a.rows)
    x = Matrix.new_vector(a.rows)
    
    for i in range(a.rows):
        y[i][0] = b[i][0] - sum([l[i][j] * y[j][0] for j in range(i)])
    
    for i in range(a.rows-1, -1, -1):
        x[i][0] = (1/u[i][i]) * (y[i][0] - sum([u[i][j] * x[j][0] for j in range(i+1, a.rows)]))
    
    return x, ((a * x) - b).norm()