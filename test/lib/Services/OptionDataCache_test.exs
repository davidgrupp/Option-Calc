defmodule OptionDataCache do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "OptionDataCache get expirations" do

    pid = OptionCalc.Services.OptionDataCache.start_link
    results = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL") |> Task.await
    
   # %{ "query" => %{ "results" => %{ "quote" => quote } } } = results
    #assert Enum.count(quote) == 2
    flunk
  end

end