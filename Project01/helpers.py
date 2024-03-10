import pandas as pd
import numpy as np

def calculate_ema(n: int, data: pd.DataFrame, from_col: str, to_col: str) -> pd.DataFrame:
    """
    Calculates the Exponential Moving Average (EMA) for a given number of periods.

    Args:
        n (int): The number of periods to consider for calculating EMA.
        data (pd.DataFrame): The input data containing the time series.
        from_col (str): The name of the column in the data frame to calculate EMA from.
        to_col (str): The name of the column in the data frame to store the calculated EMA.

    Returns:
        pd.DataFrame: The input data frame with the EMA values added as a new column.
    """
    weight = 1 - (2 / (n + 1))
    for rowIndex in range(n, len(data.index)):
        nominator = 0
        denominator = 0
        for i in range(0, n + 1):
            p = data[from_col].iloc[rowIndex - i]
            nominator += p * (weight ** i)
            denominator += weight ** i
        data.loc[rowIndex, to_col] = nominator / denominator
    return data

def get_data(path: str) -> pd.DataFrame:
    """
    Reads the data from a CSV file and preprocess it.

    Args:
        path (str): The path to the CSV file.

    Returns:
        pd.DataFrame: The preprocessed data frame with the required columns.
    """
    data = pd.read_csv(path)
    data["DATE"] = pd.to_datetime(data['<DATE>'], format='%Y%m%d')
    data["VALUE"] = data["<CLOSE>"]
    data = data[["DATE", "VALUE"]]

    calculate_ema(12, data, "VALUE", "EMA12")
    calculate_ema(26, data, "VALUE", "EMA26")
    data["MACD"] = data["EMA12"] - data["EMA26"]
    calculate_ema(9, data, "MACD", "SIGNAL")
    data["OVER"] = data["MACD"] >= data["SIGNAL"]
    data["ACTION"] = 'NONE'

    for i in range(1, len(data.index)):
        a = data.loc[i, 'OVER']
        b = data.loc[i-1, 'OVER']
        if a and not b:
            data.loc[i, "ACTION"] = 'BUY'
        elif not a and b:
            data.loc[i, "ACTION"] = 'SELL'

    return data

def simulate(data: pd.DataFrame, stocks: int) -> float:
    """
    Simulates a trading strategy and calculates the profit or loss.

    Args:
        data (pd.DataFrame): The data frame containing the preprocessed data.
        stocks (int): The number of stocks to trade with.

    Returns:
        float: The profit or loss from the trading strategy.
    """
    would_be_money = data.iloc[0, 1] * stocks
    money = 0
    for row in data.itertuples():
        if row.ACTION == 'BUY':
            if money > 0:
                stocks = money // row.VALUE
                money -= stocks * row.VALUE
        elif row.ACTION == 'SELL':
            if stocks > 0:
                money += stocks * row.VALUE
                stocks = 0
    if stocks > 0:
        money = stocks * row.VALUE
        stocks = 0
    return money - would_be_money

def get_sells_and_their_profit(data: pd.DataFrame, stocks: int) -> pd.DataFrame:
    money = 0
    last_bought_for = np.nan
    stocks_purchased = -1
    result = pd.DataFrame(columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])
    i = 0
    
    for row in data.itertuples():
        if row.ACTION == 'BUY':
            if money > 0:
                stocks = money // row.VALUE
                stocks_purchased = money // row.VALUE
                money -= stocks * row.VALUE
                last_bought_for = row.VALUE
        elif row.ACTION == 'SELL':
            if stocks > 0:
                money += stocks * row.VALUE
                diff = row.VALUE * stocks - stocks_purchased * last_bought_for
                result = pd.concat([result, pd.DataFrame([[row.DATE, last_bought_for, row.VALUE, round(diff, 2)]], columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])], ignore_index=True)
    
    if stocks > 0:
        money = stocks * row.VALUE
        diff = row.VALUE * stocks - stocks_purchased * last_bought_for
        result = pd.concat([result, pd.DataFrame([[row.DATE, last_bought_for, row.VALUE, round(diff, 2)]], columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])], ignore_index=True)
        stocks = 0
    
    result = result.rename(columns={'DATE': 'Data', 'LAST_BOUGHT_FOR': 'Cena zakupu', 'SELL_VALUE': 'Cena sprzedaży', 'PROFIT': 'Zysk'})
    return result

def simulate_with_x_day_buy_delay(data: pd.DataFrame, stocks: int, x = 2) -> float:
    """
    Simulates a trading strategy and calculates the profit or loss.

    Args:
        data (pd.DataFrame): The data frame containing the preprocessed data.
        stocks (int): The number of stocks to trade with.

    Returns:
        float: The profit or loss from the trading strategy.
    """
    would_be_money = data.iloc[0, 1] * stocks
    money = 0
    none_strike = 0
    for row in data.itertuples():
        if row.ACTION == 'BUY' and none_strike >= x:
            none_strike = 0
            if money > 0:
                stocks = money // row.VALUE
                money -= stocks * row.VALUE
        elif row.ACTION == 'SELL':
            none_strike = 0
            if stocks > 0:
                money += stocks * row.VALUE
                stocks = 0
        elif row.ACTION == 'NONE':
            none_strike += 1
    if stocks > 0:
        money = stocks * row.VALUE
        stocks = 0
    return money - would_be_money

def get_sells_and_their_profit_with_2_day_buy_delay(data: pd.DataFrame, stocks: int, x = 2) -> pd.DataFrame:
    money = 0
    last_bought_for = np.nan
    stocks_purchased = -1
    result = pd.DataFrame(columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])
    none_strike = 0
    
    for row in data.itertuples():
        if row.ACTION == 'BUY' and none_strike >= x:
            none_strike = 0
            if money > 0:
                stocks = money // row.VALUE
                stocks_purchased = money // row.VALUE
                money -= stocks * row.VALUE
                last_bought_for = row.VALUE
        elif row.ACTION == 'SELL':
            none_strike = 0
            if stocks > 0:
                money += stocks * row.VALUE
                diff = row.VALUE * stocks - stocks_purchased * last_bought_for
                result = pd.concat([result, pd.DataFrame([[row.DATE, last_bought_for, row.VALUE, round(diff, 2)]], columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])], ignore_index=True)
        elif row.ACTION == 'NONE':
            none_strike += 1
    
    if stocks > 0:
        money = stocks * row.VALUE
        diff = row.VALUE * stocks - stocks_purchased * last_bought_for
        result = pd.concat([result, pd.DataFrame([[row.DATE, last_bought_for, row.VALUE, round(diff, 2)]], columns=['DATE', 'LAST_BOUGHT_FOR', 'SELL_VALUE', 'PROFIT'])], ignore_index=True)
        stocks = 0
    
    result = result.rename(columns={'DATE': 'Data', 'LAST_BOUGHT_FOR': 'Cena zakupu', 'SELL_VALUE': 'Cena sprzedaży', 'PROFIT': 'Zysk'})
    return result
