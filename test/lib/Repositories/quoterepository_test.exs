defmodule QuoteRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Quote Repository read list" do

    results = OptionCalc.Repositories.QuoteRepository.read(["aapl","TSLA"]) |> Task.await
    assert Enum.count(results) == 2
  end

  test "Quote Repository read" do

    results = OptionCalc.Repositories.QuoteRepository.read("aapl") |> Task.await
    assert results != nil
  end

end