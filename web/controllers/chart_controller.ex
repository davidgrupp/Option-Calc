defmodule OptionCalc.ChartController do
  use OptionCalc.Web, :controller

  def index(conn, _params) do
    render conn, "show.html"
  end

  #OptionCalc.ChartController.points
  def points(conn, %{options: options}) do
    points = [%{x: 1, y: 2}]
    json conn, %{ chart: points, options: options }
  end
end