defmodule OptionCalc.Chart do
    
    def points(options, start_point, end_point, total_points) do
        
        0..total_points - 1
        |> Enum.map(fn n -> start_point + n * ((end_point - start_point) / (total_points-1)) end)
        |> Enum.concat(options |> Enum.map(fn o -> o.strike end))
        |> Enum.map(&(&1 + 0.0))
        |> Enum.uniq
        |> Enum.sort
        |> Enum.map(fn n -> %{ 
            x: n |> Float.round(3), 
            y: OptionCalc.Calc.strategy_profit(n, options) |> Float.round(3)
        } end)

    end
end