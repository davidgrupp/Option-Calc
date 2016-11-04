defmodule OptionCalc.QuoteController do
  use OptionCalc.Web, :controller

  def index(conn, %{ "symbol" => symbol }) do
    process = OptionCalc.Utilities.ServiceLocator.get_service OptionCalc.Services.OptionDataCache
    expirations = OptionCalc.Services.OptionDataCache.get_expirations(process, "symbol")
    #expirations = [1,2,3,4]
    json conn, %{ expirations: expirations }
  end
end