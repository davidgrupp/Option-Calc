defmodule OptionCalc.Repositories.QuoteRepository do
  import OptionCalc.Constants.ApiBaseUrls
  
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
	
		%{ body: content, status_code: 200 } = HTTPoison.get!(URI.encode(url))
    content
    |> Poison.decode!
  end
  
  
end