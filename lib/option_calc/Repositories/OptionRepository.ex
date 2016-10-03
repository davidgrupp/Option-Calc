defmodule OptionCalc.Repositories.OptionRepository do
  import OptionCalc.Constants.ApiBaseUrls
  
  def read_expirations(symbol) do
		IO.puts("use async")
    url = tk <> "market/options/expirations.json?symbol=#{symbol}"
    signed_oauth_headers = OptionCalc.OAuth.sign(:get, url, :tk_oauth)
    %{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url), signed_oauth_headers)
    %{ "response" => %{ "expirationdates" => %{ "date" => dates } } } = content |> Poison.decode!
    dates
    |> Enum.map(fn d -> String.split(d, "-") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn [year, month, day] -> Date.new(year, month, day) end)
  end

  def read_strike_prices(symbol, date) do
    dt = date |> Date.to_string |> String.replace("-", "")
		url = tk <> "market/options/search.json?symbol=#{symbol}&query=xdate-eq:#{dt}"
    signed_oauth_headers = OptionCalc.OAuth.sign(:get, url, :tk_oauth)
    Task.async(fn ->
      %{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url), signed_oauth_headers)
      %{ "response" => %{ "quotes" => %{ "quote" => quotes } } } = content |> Poison.decode!
      #IO.inspect(quotes)
      quotes
      |> Enum.map(fn q ->  %OptionCalc.Option{ ask: q["ask"], bid: q["bid"], close: q["close"], open: q["open"], last: q["last"], type: q["type"], strike: q["strike"] } end )
    end)
  end
end