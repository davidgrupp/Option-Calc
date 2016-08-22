defmodule OptionCalc.ChartControllerTest do
  use OptionCalc.ConnCase

  test "chart controller points", %{conn: conn} do
    params = %{
        "settings" => %{ "startPoint" => 0, "endPoint" => 1000 },
        "options" => [
          %{"price" => 12.8216, "quantity" => 1, "strike" => 100, "type" => "Call"},
          %{"price" => 5.9976, "quantity" => -1, "strike" => 120, "type" => "Call"}
        ]}
    assert OptionCalc.ChartController.points(conn, params).resp_body == 
            "{\"chart\":[{\"y\":-6.824,\"x\":0},{\"y\":-6.824,\"x\":100},{\"y\":13.176,\"x\":120},{\"y\":13.176,\"x\":1000}]}"
  end
end
