defmodule OptionCalc.QuoteController do
  use OptionCalc.Web, :controller

  def index(conn, %{ "symbol" => symbol }) do
    #expirations = OptionCalc.Services.QuoteDataCache.get_expirations(pid, "symbol")
    expirations = [1,2,3,4]
    json conn, %{ expirations: expirations }
  end
end