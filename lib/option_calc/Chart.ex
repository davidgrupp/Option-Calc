defmodule OptionCalc.Chart do
    
    def points(options, start_point, end_point) do
        options_profits = options 
        |> Enum.map(fn o ->%{ x: o.strike, y: OptionCalc.Calc.strategy_profit(o.strike, options) |> Float.round(3) } end)
        |> Enum.sort(fn p1, p2 -> p1.x < p2.x end)

        options_profits = [%{ x: start_point, y: OptionCalc.Calc.strategy_profit(start_point, options) |> Float.round(3) } | options_profits]
        options_profits ++ [%{ x: end_point, y: OptionCalc.Calc.strategy_profit(end_point, options) |> Float.round(3) }]
    end
end