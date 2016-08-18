defmodule OptionCalc.ChartController do
  use OptionCalc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def points(conn, %{"options" => options}) when is_list(options) do
    #IO.inspect(options)
    points = options 
        |> Enum.map(fn %{"strike" => strike, "price" => price, "type"=> type, "quantity"=> quantity} -> 
        %OptionCalc.Option{strike: strike, price: price, type: type, quantity: quantity} end)
        |> OptionCalc.Chart.points
    
    json conn, %{ chart: points }
  end
end