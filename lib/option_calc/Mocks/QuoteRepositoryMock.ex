defmodule OptionCalc.Mocks.Repositories.QuoteRepositoryMock do
  
  def read("AAPL") do
    Task.async(fn ->
        %OptionCalc.Quote{ask: 110.94, bid: 110.91, change: 0.1, dayshigh: 112.35,
          dayslow: 111.23, last: 111.59, name: "Apple Inc.", open: 111.4,
          percentchange: 0.09, shortratio: 1.32, symbol: "aapl", volume: 28331709}
    end)
  end

  def read("TSLA") do
    Task.async(fn ->
        %OptionCalc.Quote{ask: 187.24, bid: 186.5, change: -2.77, dayshigh: 192.7,
          dayslow: 187.51, last: 188.02, name: "Tesla Motors, Inc.", open: 190.05,
          percentchange: -1.45, shortratio: 9.48, symbol: "tsla", volume: 4253382}
    end)
  end
end