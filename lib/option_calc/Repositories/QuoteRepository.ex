defmodule OptionCalc.Repositories.QuoteRepository do
  import OptionCalc.Constants.ApiBaseUrls
  
  def read(symbol) when is_binary(symbol) do
  	read([symbol])
  end
  
  def read(list) do
	symbollist = Enum.map(list, fn x->"\""<>x<>"\"" end)|>Enum.reduce(fn(x, acc)-> acc<>", "<>x end)
	query = "select 
			symbol, Ask, Bid, AskRealtime, BidRealtime, BookValue, Change_PercentChange, Change, Currency, 
			ChangeRealtime, AfterHoursChangeRealtime, DividendShare, LastTradeDate, TradeDate, EarningsShare, 
			ErrorIndicationreturnedforsymbolchangedinvalid, DaysLow, DaysHigh, LastTradeRealtimeWithTime, 
			ChangePercentRealtime, LastTradeWithTime, LastTradePriceOnly, HighLimit, LowLimit, DaysRange, 
			DaysRangeRealtime, Name, Open, PreviousClose, ChangeinPercent, PriceSales, Symbol, ShortRatio, 
			LastTradeTime, Volume, DaysValueChange, DaysValueChangeRealtime, StockExchange, PercentChange 
			from yahoo.finance.quotes where symbol in (#{symbollist})"
	url = yql <> "?q=#{query}&format=json&env=store://datatables.org/alltableswithkeys"
	Task.async(fn ->
		%{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url))
		%{ "query" => %{ "results" => %{ "quote" => quote } } } = Poison.decode!(content)
		if(is_list(quote)) do
			quote |> Enum.map(fn q ->map_quote (q) end)
		else
		    map_quote(quote)
		end
	end)
  end
  
  defp map_quote(q) do
    %OptionCalc.Quote {
						dayslow: q["DaysLow"] |> to_float_or_default,
						dayshigh: q["DaysHigh"] |> to_float_or_default,
						symbol: q["Symbol"],
						name: q["Name"],
						percentchange: q["PercentChange"] |> String.trim("%") |> to_float_or_default,
						change: q["Change"] |> to_float_or_default,
						volume: q["Volume"] |> to_int_or_default,
						shortratio: q["ShortRatio"] |> to_float_or_default,
						open: q["Open"] |> to_float_or_default,
						last: q["LastTradePriceOnly"] |> to_float_or_default,
						ask: q["Ask"] |> to_float_or_default,
						bid: q["Bid"] |> to_float_or_default
					}
  end

	defp to_float_or_default(v, default \\ nil)
	defp to_float_or_default(nil, default), do: default
	defp to_float_or_default(value, _), do: value |> String.to_float
	defp to_int_or_default(v, default \\ nil)
	defp to_int_or_default(nil, default), do: default
	defp to_int_or_default(value, _), do: value |> String.to_integer(10)

end
