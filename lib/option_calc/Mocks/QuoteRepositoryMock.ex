defmodule OptionCalc.Mocks.Repositories.QuoteRepositoryMock do
  
  def read("AAPL") do
    Task.async(fn ->
        [~D"2016-10-07", ~D"2016-10-14", :rand.uniform(10000)]
    end)
  end

end