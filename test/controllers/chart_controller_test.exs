defmodule OptionCalc.ChartControllerTest do
  use OptionCalc.ConnCase

  test "chart controller points", %{conn: conn} do
    params = %{
        "settings" => %{ "startPoint" => 90, "endPoint" => 130 },
        "options" => [
          %{"price" => 12.8216, "quantity" => 1, "strike" => 100, "type" => "Call"},
          %{"price" => 5.9976, "quantity" => -1, "strike" => 120, "type" => "Call"}
        ]}
    assert OptionCalc.ChartController.points(conn, params).resp_body == 
            "{\"chart\":[{\"y\":-6.824,\"x\":90.0},{\"y\":-6.824,\"x\":92.105},{\"y\":-6.824,\"x\":94.211},{\"y\":-6.824,\"x\":96.316},{\"y\":-6.824,\"x\":98.421},{\"y\":-6.824,\"x\":100.0},{\"y\":-6.298,\"x\":100.526},{\"y\":-4.192,\"x\":102.632},{\"y\":-2.087,\"x\":104.737},{\"y\":0.018,\"x\":106.842},{\"y\":2.123,\"x\":108.947},{\"y\":4.229,\"x\":111.053},{\"y\":6.334,\"x\":113.158},{\"y\":8.439,\"x\":115.263},{\"y\":10.544,\"x\":117.368},{\"y\":12.65,\"x\":119.474},{\"y\":13.176,\"x\":120.0},{\"y\":13.176,\"x\":121.579},{\"y\":13.176,\"x\":123.684},{\"y\":13.176,\"x\":125.789},{\"y\":13.176,\"x\":127.895},{\"y\":13.176,\"x\":130.0}]}"
  end

  test "chart controller points invalid position types", %{conn: conn} do
    params = %{
        "settings" => %{ "startPoint" => 90, "endPoint" => 130 },
        "options" => [
          %{"price" => 12.8216, "quantity" => 1, "strike" => 100, "type" => "Blah"},
          %{"price" => 5.9976, "quantity" => -1, "strike" => 120, "type" => "Thing"}
        ]}
    
    assert_raise FunctionClauseError, fn-> OptionCalc.ChartController.points(conn, params) end
  end
end
