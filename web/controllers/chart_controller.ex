defmodule OptionCalc.ChartController do
  use OptionCalc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def points(conn, %{ "settings" => settings, "options" => options }) when is_list(options) do
    #IO.inspect(options)
    startPoint = settings["startPoint"]
    endPoint = settings["endPoint"]
    optionsx100 = settings["optionsx100"]
    points = options 
        |> Enum.map(fn %{"strike" => strike, "price" => price, "type"=> type, "quantity"=> quantity} -> 
        %OptionCalc.Option{strike: strike, price: price, type: type, quantity: quantity} end)
        |> OptionCalc.Chart.points(startPoint, endPoint, 20)
    
    json conn, %{ chart: points }
  end
end