defmodule OptionCalc.Mocks.Repositories.OptionRepositoryMock do
  
  def read_expirations(_symbol) do
    Task.async(fn ->
        [~D"2016-10-07", ~D"2016-10-14"]
    end)
  end

  def read_strike_prices(_symbol, _date) do
    Task.async(fn ->
      [ %OptionCalc.Option{ ask: 5.25, bid: 5.26, close: 5.25, open: 5.25, last: 5.25, type: "call", strike: 100 } ]
    end)
  end
end


IO.puts("in OptionRepositoryMock")
