from math import cos, pi
from typing import List, Tuple, Callable
from matrix import Matrix
import pandas as pd

def read_nodes(file_path: str) -> List[Tuple[float, float]]:
    """
    Reads nodes from a CSV file.
    """

    return [(row.iloc[0], row.iloc[1]) for _, row in pd.read_csv(file_path).iterrows()]

def get_x_values(data: List[Tuple[float, float]]) -> List[float]:
    """
    Returns the x values from data.
    """

    return [x for x, _ in data]

def get_y_values(data: List[Tuple[float, float]]) -> List[float]:
    """
    Returns the y values from data.
    """

    return [y for _, y in data]

def linspace(start: float, end: float, n: int) -> List[float]:
    """
    Returns a list of n evenly spaced values between start and end.
    """

    if (n == 0):
        return []
    if (n == 1):
        return [start]
    return [start + (end - start) * i / (n - 1) for i in range(n)]

def chebyshev_nodes(start: float, end: float, n: int) -> List[float]:
    """
    Returns a list of n Chebyshev nodes between start and end.
    """

    return [(start + end) / 2 + (end - start) / 2 * cos((2 * i + 1) * pi / (2 * n)) for i in range(n)][::-1]

def get_selection_points(nodes: List[Tuple[float, float]], strategy: Callable[[float, float, int], List[float]], n: int) -> List[Tuple[float, float]]:
    """
    Returns the selection points based on the strategy.
    """

    correct_nodes = strategy(nodes[0][0], nodes[-1][0], n)

    # Find the closest nodes to correct_nodes from nodes.
    result = []
    for node in correct_nodes:
        closest_node = min(nodes, key=lambda x: abs(x[0] - node))
        if closest_node not in result:
            result.append(closest_node)
    return result

def get_interpolation_points(nodes: List[Tuple[float, float]], n: int) -> List[float]:
    """
    Returns the interpolation points.
    """

    return linspace(nodes[0][0], nodes[-1][0], n)

def lagrange_interpolation(data: List[Tuple[float, float]], x_values: List[float]) -> List[float]:
    """
    Returns the values of the Lagrange interpolation polynomial at x_values.
    """

    y_values = []
    for x in x_values:
        n = len(data)
        result = 0.0
        for i in range(n):
            xi, yi = data[i]
            term = yi
            for j in range(n):
                if j != i:
                    xj, _ = data[j]
                    term *= (x - xj) / (xi - xj)
            result += term
        y_values.append(result)
    return y_values

def cubic_spline_interpolation(data: List[Tuple[float, float]], x_values: List[float]) -> List[float]:
    """
    Returns the values of the spline interpolation polynomial at x_values.

    Tested with: https://tools.timodenk.com/cubic-spline-interpolation
    """

    number_of_sub_ranges = len(data) - 1
    n = 4 * number_of_sub_ranges

    A = Matrix.new_square(n)
    b = Matrix.new_vector(n)

    row_id = 0

    for i in range(number_of_sub_ranges):
        A[row_id][i * 4] = 1
        b[row_id] = data[i][1]
        row_id += 1

        h = data[i + 1][0] - data[i][0]
        A[row_id][i * 4] = 1
        A[row_id][i * 4 + 1] = h
        A[row_id][i * 4 + 2] = h ** 2
        A[row_id][i * 4 + 3] = h ** 3
        b[row_id] = data[i + 1][1]
        row_id += 1

        if i < number_of_sub_ranges - 1:
            A[row_id][i * 4 + 1] = 1
            A[row_id][i * 4 + 2] = 2 * h
            A[row_id][i * 4 + 3] = 3 * h ** 2
            A[row_id][(i + 1) * 4 + 1] = -1
            row_id += 1
        
            A[row_id][i * 4 + 2] = 2
            A[row_id][i * 4 + 3] = 6 * h
            A[row_id][(i + 1) * 4 + 2] = -2
            row_id += 1
        
    A[row_id][2] = 1
    row_id += 1

    A[row_id][n - 2] = 2
    A[row_id][n - 1] = 6 * (data[-1][0] - data[-2][0])
    row_id += 1

    x = A.solve(b).to_flat_list()

    results = []
    for x_value in x_values:
        found = False
        for i in range(number_of_sub_ranges):
            if data[i][0] <= x_value <= data[i + 1][0]:
                h = x_value - data[i][0]
                results.append(x[i * 4] + x[i * 4 + 1] * h + x[i * 4 + 2] * h ** 2 + x[i * 4 + 3] * h ** 3)
                found = True
                break
        if not found:
            results.append(results[-1])        
    return results