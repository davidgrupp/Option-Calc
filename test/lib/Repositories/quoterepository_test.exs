defmodule QuoteRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Quote Repository read" do

    results = OptionCalc.Repositories.QuoteRepository.read(["aapl","TSLA"]) |> Task.await
    
    %{ "query" => %{ "results" => %{ "quote" => quote } } } = results
    assert Enum.count(quote) == 2
  end

end