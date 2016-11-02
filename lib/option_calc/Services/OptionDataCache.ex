defmodule OptionCalc.Services.OptionDataCache do
  
  @option_repo Application.get_env(:option_calc, :option_repo)
  use OptionCalc.Utilities.GenDataCache, timeout: 10*60*60

  def get_expirations(pid, symbol) do
    get_value(pid, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_expirations_async(pid, symbol) do
    get_value_async(pid, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_strike_prices(pid, symbol, date) do
    get_value(pid, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def get_strike_prices_async(pid, symbol, date) do
    get_value_async(pid, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def set_expirations(pid, symbol, value) do
    set_value(pid, {:expirations, symbol}, value)
  end

  def set_strike_prices(pid, symbol, date, value) do
    set_value(pid, {:strikes, symbol, date}, value)
  end

end