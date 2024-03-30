from matrix import Matrix
from matrix_algorithms import solve_lu

def test_solve_lu_1():
    """
    Test the solve_lu function.

    Based on: https://byjus.com/maths/lu-decomposition/
    """
    A = Matrix([[1, 1, 1], [3, 1, -3], [1, -2, -5]])
    B = Matrix([[1], [5], [10]])

    x = solve_lu(A, B)

    assert x[0][0] == 6
    assert x[1][0] == -7
    assert x[2][0] == 2

def test_solve_lu_2():
    """
    Test the solve_lu function.
    
    Based on: https://www.wolframalpha.com/input?i=system+equation+calculator&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation1%22%7D+-%3E%226x+%2B+18y+%2B+3z+%3D+3%22&assumption=%22FSelect%22+-%3E+%7B%7B%22SolveSystemOf3EquationsCalculator%22%7D%2C+%22dflt%22%7D&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation2%22%7D+-%3E%222x+%2B+12y+%2B+z+%3D+19%22&assumption=%7B%22F%22%2C+%22SolveSystemOf3EquationsCalculator%22%2C+%22equation3%22%7D+-%3E%224x+%2B+15y+%2B+3z+%3D+0%22
    """
    A = Matrix([[6, 18, 3], [2, 12, 1], [4, 15, 3]])
    B = Matrix([[3], [19], [0]])

    x = solve_lu(A, B)

    assert x[0][0] == -3
    assert x[1][0] == 3
    assert x[2][0] == -11