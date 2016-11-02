defmodule OptionDataCacheTests do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "OptionDataCache get expirations" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL")
    results2 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    results3 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    [~D"2016-10-07", ~D"2016-10-14", _] = results1 
    [~D"2016-10-07", ~D"2016-10-21", _] = results2 
    assert results2 == results3
  end

  test "OptionDataCache get expirations async" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "AAPL") |> Task.await
    results2 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    results3 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    [~D"2016-10-07", ~D"2016-10-14", _] = results1 
    [~D"2016-10-07", ~D"2016-10-21", _] = results2 
    assert results2 == results3
  end

  test "OptionDataCache get strike prices" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_strike_prices(pid, "AAPL", ~D"2016-10-14")
    results2 = OptionCalc.Services.OptionDataCache.get_strike_prices(pid, "TSLA", ~D"2016-10-14")
    results3 = OptionCalc.Services.OptionDataCache.get_strike_prices(pid, "TSLA", ~D"2016-10-14")
    [ %OptionCalc.Option{ ask: 5.25, bid: 5.26, close: 5.25, open: 5.25, last: 5.25, type: "call", strike: 100 }, _ ] = results1
    [ %OptionCalc.Option{ ask: 7.25, bid: 7.26, close: 7.25, open: 7.25, last: 7.25, type: "call", strike: 100 }, _ ] = results2
    assert results2 == results3
  end

  test "OptionDataCache get strike prices async" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_strike_prices_async(pid, "AAPL", ~D"2016-10-14") |> Task.await
    results2 = OptionCalc.Services.OptionDataCache.get_strike_prices_async(pid, "TSLA", ~D"2016-10-14") |> Task.await
    results3 = OptionCalc.Services.OptionDataCache.get_strike_prices_async(pid, "TSLA", ~D"2016-10-14") |> Task.await
    [ %OptionCalc.Option{ ask: 5.25, bid: 5.26, close: 5.25, open: 5.25, last: 5.25, type: "call", strike: 100 }, _ ] = results1
    [ %OptionCalc.Option{ ask: 7.25, bid: 7.26, close: 7.25, open: 7.25, last: 7.25, type: "call", strike: 100 }, _ ] = results2
    assert results2 == results3
  end

  test "OptionDataCache is_valid is valid" do
    valid = %{ cached_on: DateTime.utc_now }
    result = OptionCalc.Services.OptionDataCache.is_valid(valid)
    assert result == true
  end

  test "OptionDataCache is_valid is invalid" do
    invalid = %{ cached_on: DateTime.from_unix!(1) }
    result = OptionCalc.Services.OptionDataCache.is_valid(invalid)
    assert result == false
  end

  test "OptionDataCache set_value" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    OptionCalc.Services.OptionDataCache.set_value(pid, {:expirations, "AAPL"}, 123)
    OptionCalc.Services.OptionDataCache.set_value(pid, {:expirations, "AAPL"}, 234)
    Agent.get(pid, fn %{ {:expirations, "AAPL"} => %{cached_on: _, status: :ready, value: 234} } = state -> state  end)
    assert true
  end

  test "OptionDataCache set_expirations" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    OptionCalc.Services.OptionDataCache.set_expirations(pid, "AAPL", 123)
    OptionCalc.Services.OptionDataCache.set_expirations(pid, "AAPL", 234)
    results = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL")
    assert results == 234
  end

  test "OptionDataCache set_strike_prices" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    OptionCalc.Services.OptionDataCache.set_strike_prices(pid, "AAPL", ~D"2016-10-14", 123)
    OptionCalc.Services.OptionDataCache.set_strike_prices(pid, "AAPL", ~D"2016-10-14", 234)
    results = OptionCalc.Services.OptionDataCache.get_strike_prices(pid, "AAPL", ~D"2016-10-14")
    assert results == 234
  end

end