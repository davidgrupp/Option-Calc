defmodule OptionChartTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Chart points" do
    options = 
      [%{strike: 100, price: 12.8216, type: "Call", quantity: 1},
      %{strike: 120, price: 5.9976, type: "Call", quantity: -1}]
    
    assert OptionCalc.Chart.points(options)
        == [%{x: 0, y: -6.824},
            %{x: 100, y: -6.824},
            %{x: 120, y: 13.176},
            %{x: 100000, y: 13.176}] 
  end




end
