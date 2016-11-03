defmodule QuoteDataCacheTests do
  use ExUnit.Case

  test "QuoteDataCache get quote" do
    { :ok, pid } = OptionCalc.Services.QuoteDataCache.start_link
    results1 = OptionCalc.Services.QuoteDataCache.get_quote(pid, "AAPL")
    results2 = OptionCalc.Services.QuoteDataCache.get_quote(pid, "TSLA")
    results3 = OptionCalc.Services.QuoteDataCache.get_quote(pid, "TSLA")
    %OptionCalc.Quote{ask: 110.94, bid: 110.91, change: 0.1, dayshigh: 112.35,
          dayslow: 111.23, last: 111.59, name: "Apple Inc.", open: 111.4,
          percentchange: 0.09, shortratio: 1.32, symbol: "aapl", volume: 28331709} = results1 
    %OptionCalc.Quote{ask: 187.24, bid: 186.5, change: -2.77, dayshigh: 192.7,
          dayslow: 187.51, last: 188.02, name: "Tesla Motors, Inc.", open: 190.05,
          percentchange: -1.45, shortratio: 9.48, symbol: "tsla", volume: 4253382} = results2 
    assert results2 == results3
  end

  test "QuoteDataCache get quote async" do
    { :ok, pid } = OptionCalc.Services.QuoteDataCache.start_link
    results1 = OptionCalc.Services.QuoteDataCache.get_quote_async(pid, "AAPL") |> Task.await
    results2 = OptionCalc.Services.QuoteDataCache.get_quote_async(pid, "TSLA") |> Task.await
    results3 = OptionCalc.Services.QuoteDataCache.get_quote_async(pid, "TSLA") |> Task.await
    %OptionCalc.Quote{ask: 110.94, bid: 110.91, change: 0.1, dayshigh: 112.35,
          dayslow: 111.23, last: 111.59, name: "Apple Inc.", open: 111.4,
          percentchange: 0.09, shortratio: 1.32, symbol: "aapl", volume: 28331709} = results1 
    %OptionCalc.Quote{ask: 187.24, bid: 186.5, change: -2.77, dayshigh: 192.7,
          dayslow: 187.51, last: 188.02, name: "Tesla Motors, Inc.", open: 190.05,
          percentchange: -1.45, shortratio: 9.48, symbol: "tsla", volume: 4253382} = results2  
    assert results2 == results3
  end

  test "QuoteDataCache set_quote" do
    { :ok, pid } = OptionCalc.Services.QuoteDataCache.start_link
    OptionCalc.Services.QuoteDataCache.set_quote(pid, "AAPL", 123)
    OptionCalc.Services.QuoteDataCache.set_quote(pid, "AAPL", 234)
    results = OptionCalc.Services.QuoteDataCache.get_quote(pid, "AAPL")
    assert results == 234
  end

end