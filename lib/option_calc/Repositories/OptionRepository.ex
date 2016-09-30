defmodule OptionCalc.Repositories.OptionRepository do
  import OptionCalc.Constants.ApiBaseUrls
  
  def read_expirations(symbol) do
		url = tk <> "market/options/expirations.json?symbol=#{symbol}"
	
		%{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url))
    content
    |> Poison.decode!
  end
  
  
end