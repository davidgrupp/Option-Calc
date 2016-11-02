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
		quote
		|> Enum.map(fn q ->
					%OptionCalc.Quote {
						dayslow: q["DaysLow"] |> String.to_float,
						dayshigh: q["DaysHigh"] |> String.to_float,
						symbol: q["Symbol"],
						name: q["Name"],
						percentchange: q["PercentChange"] |> String.trim("%") |> String.to_float,
						change: q["Change"] |> String.to_float,
						volume: q["Volume"] |> String.to_integer(10),
						shortratio: q["ShortRatio"] |> String.to_float,
						open: q["Open"] |> String.to_float,
						last: q["LastTradePriceOnly"] |> String.to_float,
						ask: q["Ask"] |> String.to_float,
						bid: q["Bid"] |> String.to_float
					}
				end)
	end)
  end
  
end