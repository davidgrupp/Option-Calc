defmodule OptionCalc.Mocks.Repositories.OptionRepositoryMock do
  
  def read_expirations("AAPL") do
    Task.async(fn ->
        [~D"2016-10-07", ~D"2016-10-14", :rand.uniform(10000)]
    end)
  end
  
  def read_expirations("TSLA") do
    Task.async(fn ->
        [~D"2016-10-07", ~D"2016-10-21", :rand.uniform(10000)]
    end)
  end

  def read_strike_prices("AAPL", _date) do
    Task.async(fn ->
      [ %OptionCalc.Option{ ask: 5.25, bid: 5.26, close: 5.25, open: 5.25, last: 5.25, type: "call", strike: 100 }, :rand.uniform(10000) ]
    end)
  end

  def read_strike_prices("TSLA", _date) do
    Task.async(fn ->
      [ %OptionCalc.Option{ ask: 7.25, bid: 7.26, close: 7.25, open: 7.25, last: 7.25, type: "call", strike: 100 }, :rand.uniform(10000) ]
    end)
  end

end



