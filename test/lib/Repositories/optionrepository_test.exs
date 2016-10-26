defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read expirations" do
    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl") |> Task.await
    assert Enum.count(results) > 3
  end

  test "Option Repository read strike prices" do
    today_erl = DateTime.utc_now |> DateTime.to_date |> Date.to_erl
    day_of_week = :calendar.day_of_the_week today_erl
    friday_erl = :calendar.gregorian_days_to_date(:calendar.date_to_gregorian_days(today_erl) + (12 - day_of_week)) # 12 for the friday after next so we can always get a friday in the future
    next_friday = Date.from_erl! friday_erl

    results = OptionCalc.Repositories.OptionRepository.read_strike_prices("aapl", next_friday) |> Task.await
    assert Enum.count(results) > 3
  end
end