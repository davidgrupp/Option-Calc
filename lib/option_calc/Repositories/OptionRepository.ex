defmodule OptionCalc.Repositories.OptionRepository do
  import OptionCalc.Constants.ApiBaseUrls
  
  def read_expirations(symbol) do
		url = tk <> "market/options/expirations.json?symbol=#{symbol}"
    signed_oauth_headers = OptionCalc.OAuth.sign(:get, url, :tk_oauth)
		%{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url), signed_oauth_headers)
    content
    |> Poison.decode!
  end
  
  
end