defmodule OptionDataCacheTests do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "OptionDataCache get expirations" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "AAPL")
    results2 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    results3 = OptionCalc.Services.OptionDataCache.get_expirations(pid, "TSLA")
    assert results1 == [~D"2016-10-07", ~D"2016-10-14"]
    assert results2 == [~D"2016-10-07", ~D"2016-10-14"]
    assert results2 == results3
  end

  test "OptionDataCache get expirations async" do
    { :ok, pid } = OptionCalc.Services.OptionDataCache.start_link
    results1 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "AAPL") |> Task.await
    results2 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    results3 = OptionCalc.Services.OptionDataCache.get_expirations_async(pid, "TSLA") |> Task.await
    assert results1 == [~D"2016-10-07", ~D"2016-10-14"]
    assert results2 == [~D"2016-10-07", ~D"2016-10-14"]
    assert results2 == results3
  end

end