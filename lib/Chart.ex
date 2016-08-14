defmodule OptionCalc.Chart do
    
    def points(options) do
        options_profits = options 
        |> Enum.map(fn o ->%{ x: o.strike, y: OptionCalc.Calc.strategy_profit(o.strike, options) |> Float.round(3) } end)
        |> Enum.sort(fn p1, p2 -> p1.x < p2.x end)

        options_profits = [%{ x: 0, y: OptionCalc.Calc.strategy_profit(0, options) |> Float.round(3) } | options_profits]
        options_profits ++ [%{ x: 100000, y: OptionCalc.Calc.strategy_profit(100000, options) |> Float.round(3) }]
    end
end