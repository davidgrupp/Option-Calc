defmodule OptionCalc.Services.QuoteDataCache do
  
  @quote_repo Application.get_env(:option_calc, :quote_repo)
  use OptionCalc.Utilities.GenDataCache, timeout: 3*60*60
	
  def get_quote(process, symbol) do
    get_value(process, symbol, fn symbol -> @quote_repo.read(symbol) |> Task.await end)
  end

  def get_quote_async(process, symbol) do
    get_value_async(process, symbol, fn symbol -> @quote_repo.read(symbol) |> Task.await end)
  end

  def set_quote(process, symbol, value) do
    set_value(process, symbol, value)
  end

end