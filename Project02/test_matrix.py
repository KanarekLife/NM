from main import Matrix
from numpy.testing import assert_almost_equal

def test_jacob_i():
    """"
    Test the Jacobi method for solving linear systems (based on https://byjus.com/maths/jacobian-method/)
    """

    a = Matrix([[4, 2, -2], [1, -3, -1], [3, -1, 4]])
    b = Matrix([[0], [7], [5]])
    x = Matrix.solve_jacobi(a, b, 1e-4)

    
    assert_almost_equal(x[0][0], 1.7083, 4)
    assert_almost_equal(x[1][0], -1.9583, 4)
    assert_almost_equal(x[2][0], -0.7812, 4)

def test_jacobi_2():
    """"
    Test the Jacobi method for solving linear systems (based on https://atozmath.com/CONM/GaussEli.aspx?q=GJ2&q1=2%602x%2b5y%3d16%3b3x%2by%3d11%60GJ2%60%601.25%60false&dm=D&dp=4&do=1#PrevPart)
    """

    a = Matrix([[2, 5], [3,1]])
    b = Matrix([[16], [11]])
    x = Matrix.solve_jacobi(a, b, 2)

    
    assert_almost_equal(x[0][0], -19.5, 1)
    assert_almost_equal(x[1][0], -13, 1)

def test_gauss_seidel_1():
    """"
    Test the Gauss-Seidel method for solving linear systems (based on https://atozmath.com/example/conm/GaussEli.aspx?q=GS2&q1=E1)
    """

    a = Matrix([[2,1], [1, 2]])
    b = Matrix([[8], [1]])
    x = Matrix.solve_gauss_seidel(a, b, 7)

    assert_almost_equal(x[0][0], 4.9998, 4)
    assert_almost_equal(x[1][0], -1.9999, 4)