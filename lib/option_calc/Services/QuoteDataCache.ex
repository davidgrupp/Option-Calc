defmodule OptionCalc.Services.QuoteDataCache do
  
  @quote_repo Application.get_env(:option_calc, :quote_repo)
  use OptionCalc.Utilities.GenDataCache, timeout: 3*60*60
	
  def get_quotes(pid, symbol) do
    get_value(pid, symbol, fn symbol -> @quote_repo.read(symbol) |> Task.await end)
  end

  def get_quotes_async(pid, symbol) do
    get_value_async(pid, symbol, fn symbol -> @quote_repo.read(symbol) |> Task.await end)
  end

  def set_quotes(pid, symbol, value) do
    set_value(pid, symbol, value)
  end

end