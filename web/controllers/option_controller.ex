defmodule OptionCalc.OptionController do
  use OptionCalc.Web, :controller

  def expirations(conn, %{ "symbol" => symbol }) do
    #expirations = OptionCalc.Services.OptionDataCache.get_expirations(pid, "symbol")
    process = OptionCalc.Utilities.ServiceLocator.get_service OptionCalc.Services.OptionDataCache
    IO.inspect(process)
    expirations = OptionCalc.Services.OptionDataCache.get_expirations(process, symbol)
    #expirations = [1,2,3,4]
    json conn, %{ expirations: expirations }
  end
end