defmodule ThingDataCache do
  
  use OptionCalc.Utilities.GenDataCache, timeout: 10*60*60

end

defmodule GenDataCacheTests do
  use ExUnit.Case
  
  test "GenDataCache is_valid is valid" do
    valid = %{ cached_on: DateTime.utc_now }
    result = ThingDataCache.is_valid(valid)
    assert result == true
  end

  test "GenDataCache is_valid is invalid" do
    invalid = %{ cached_on: DateTime.from_unix!(1) }
    result = ThingDataCache.is_valid(invalid)
    assert result == false
  end

  test "GenDataCache set_value" do
    { :ok, pid } = ThingDataCache.start_link
    ThingDataCache.set_value(pid, "ABC", 123)
    ThingDataCache.set_value(pid, "ABC", 234)
    result = Agent.get(pid, fn %{ "ABC" => %{cached_on: _, status: :ready, value: 234} } = state -> state  end)
    assert result != nil
  end

  test "GenDataCache get_value" do
    { :ok, pid } = ThingDataCache.start_link
    result1 = ThingDataCache.get_value(pid, "ABC", fn _ -> 123 end)
    result2 = ThingDataCache.get_value(pid, "ABC", fn _ -> 234 end)
    assert result1 == 123
    assert result2 == 123, "should still return 123 since value is cached"
  end

  test "GenDataCache get_value_async" do
    { :ok, pid } = ThingDataCache.start_link
    #test running query func and race conditions
    result1 = ThingDataCache.get_value_async(pid, "ABC", fn _ -> 123 end)
    result2 = ThingDataCache.get_value_async(pid, "ABC", fn _ -> 234 end)
    assert result1 |> Task.await == 123
    assert result2 |> Task.await == 123 #, "should still return 123 since value is cached"

    #test getting value from cache
    result3 = ThingDataCache.get_value_async(pid, "ABC", fn _ -> 345 end)
    assert result3 |> Task.await == 123
  end

end