defmodule OptionRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Option Repository read" do

    results = OptionCalc.Repositories.OptionRepository.read_expirations("aapl")
    IO.inspect results
    %{ "query" => %{ "results" => %{ "quote" => quote } } } = results
    assert Enum.count(quote) == 2
  end

end