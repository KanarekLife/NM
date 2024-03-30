from main import Matrix
from numpy.testing import assert_almost_equal

def test_norm():
    """
    Test the norm method for matrices (based on https://nucinkis-lab.cc.ic.ac.uk/HELM/workbooks/workbook_30/30_4_matrx_norms.pdf)
    """

    a = Matrix([[1, -7], [-2, -3]])
    assert_almost_equal(a.norm(), 7.937, 3)

def test_matrix_by_scalar_multiplication():
    a = Matrix([[1, 2], [3, 4]])
    b = a * 2
    assert b[0][0] == 2
    assert b[0][1] == 4
    assert b[1][0] == 6
    assert b[1][1] == 8

def test_matrix_multiplication():
    """
    Test the matrix multiplication method for matrices (based on https://www.mathsisfun.com/algebra/matrix-multiplying.html)
    """

    a = Matrix([[1, 2, 3], [4, 5, 6]])
    b = Matrix([[7, 8], [9, 10], [11, 12]])
    c = a * b
    
    assert c[0][0] == 58
    assert c[0][1] == 64
    assert c[1][0] == 139
    assert c[1][1] == 154

def test_matrix_subtraction():
    a = Matrix([[1, 2], [3, 4]])
    b = Matrix([[1, 1], [1, 1]])
    c = a - b

    assert c[0][0] == 0
    assert c[0][1] == 1
    assert c[1][0] == 2
    assert c[1][1] == 3