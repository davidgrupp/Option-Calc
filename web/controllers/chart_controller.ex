defmodule OptionCalc.ChartController do
  use OptionCalc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def points(conn, %{ "settings" => settings, "positions" => positions }) when is_list(positions) do
    #IO.inspect(positionss)
    startPoint = settings["startPoint"]
    endPoint = settings["endPoint"]
    optionsx100 = settings["Optionsx100"]
    points = positions 
        |> Enum.map(fn %{"strike" => strike, "price" => price, "type"=> type, "quantity"=> quantity} when type in ["Call", "Put", "Stock"] -> 
        %OptionCalc.Option{strike: strike, price: price, type: String.to_atom(type |> String.downcase), quantity: quantity} end)
        |> OptionCalc.Chart.points(startPoint, endPoint, 20)
    
    json conn, %{ chart: points }
  end
end