defmodule OptionChartTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Chart points" do
    options = 
      [%OptionCalc.Option{strike: 100, price: 12.8216, type: :call, quantity: 1},
      %OptionCalc.Option{strike: 120, price: 5.9976, type: :call, quantity: -1}]
    
    assert OptionCalc.Chart.points(options, 90, 130, 5)
        == [%{x: 90, y: -6.824},
            %{x: 100, y: -6.824},
            %{x: 110, y: 3.176},
            %{x: 120, y: 13.176},
            %{x: 130, y: 13.176}] 
  end

end
