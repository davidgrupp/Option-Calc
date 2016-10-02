defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read expirations" do

    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl")
    %{ "response" => %{ "expirationdates" => %{ "date" => dates } } } = results
    assert Enum.count(dates) > 3
  end

  test "Option Repository read strikes" do

    results = OptionCalc.Repositories.OptionRepository.read_strikes("aapl")
    %{ "response" => %{ "prices" => %{ "price" => prices } } } = results
    assert Enum.count(prices) > 3
  end
end