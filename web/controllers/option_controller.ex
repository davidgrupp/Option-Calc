defmodule OptionCalc.OptionController do
  use OptionCalc.Web, :controller

  def expirations(conn, %{ "symbol" => symbol }) do
    #expirations = OptionCalc.Services.OptionDataCache.get_expirations(pid, "symbol")
    expirations = [1,2,3,4]
    json conn, %{ expirations: expirations }
  end
end