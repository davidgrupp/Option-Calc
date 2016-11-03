defmodule QuoteDataCacheTests do
  use ExUnit.Case

  test "QuoteDataCache get expirations" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL")
    results2 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    results3 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    [~D"2016-10-07", ~D"2016-10-14", _] = results1 
    [~D"2016-10-07", ~D"2016-10-21", _] = results2 
    assert results2 == results3
  end

  test "QuoteDataCache get expirations async" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "AAPL") |> Task.await
    results2 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    results3 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    [~D"2016-10-07", ~D"2016-10-14", _] = results1 
    [~D"2016-10-07", ~D"2016-10-21", _] = results2 
    assert results2 == results3
  end

  test "QuoteDataCache set_value" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    OptionCalc.Services.OptionDataCache.set_value(pid, {:expirations, "AAPL"}, 123)
    OptionCalc.Services.OptionDataCache.set_value(pid, {:expirations, "AAPL"}, 234)
    result = Agent.get(pid, fn %{ {:expirations, "AAPL"} => %{cached_on: _, status: :ready, value: 234} } = state -> state  end)
    assert result != nil
  end

  test "QuoteDataCache set_expirations" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    OptionCalc.Services.OptionDataCache.set_expirations(pid, "AAPL", 123)
    OptionCalc.Services.OptionDataCache.set_expirations(pid, "AAPL", 234)
    results = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL")
    assert results == 234
  end

end