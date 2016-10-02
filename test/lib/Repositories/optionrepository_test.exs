defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read expirations" do
    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl")
    assert Enum.count(results) > 3
  end

  test "Option Repository read strike pricess" do

    results = OptionCalc.Repositories.OptionRepository.read_strike_prices("aapl", ~D[2010-10-07])
    assert Enum.count(results) > 3
  end
end