defmodule OptionCalc.Services.OptionDataCache do
  
  @option_repo Application.get_env(:option_calc, :option_repo)
  use OptionCalc.Utilities.GenDataCache, timeout: 10*60*60

  def get_expirations(process, symbol) do
    get_value(process, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_expirations_async(process, symbol) do
    get_value_async(process, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_strike_prices(process, symbol, date) do
    get_value(process, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def get_strike_prices_async(process, symbol, date) do
    get_value_async(process, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def set_expirations(process, symbol, value) do
    set_value(process, {:expirations, symbol}, value)
  end

  def set_strike_prices(process, symbol, date, value) do
    set_value(process, {:strikes, symbol, date}, value)
  end

end