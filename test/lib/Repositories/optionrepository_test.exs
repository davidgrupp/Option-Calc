defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read expirations" do
    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl") |> Task.await
    assert Enum.count(results) > 3
  end

  test "Option Repository read strike prices" do

    results = OptionCalc.Repositories.OptionRepository.read_strike_prices("aapl", ~D[2016-10-07]) |> Task.await
    assert Enum.count(results) > 3
  end
end