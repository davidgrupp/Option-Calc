defmodule QuoteRepositoryTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Quote read" do

    result = OptionCalc.Repositories.QuoteRepository.read(["aapl","TSLA"])
    
     IO.puts result
    
    assert false
    #assert String.length(content) > 0
  end

end