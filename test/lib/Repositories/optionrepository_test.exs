defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read" do

    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl")
    %{ "response" => %{ "expirationdates" => %{ "date" => dates } } } = results
    assert Enum.count(dates) > 3
  end

end