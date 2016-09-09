defmodule OptionCalc.Calc do
    
    def strategy_profit(value, options) do
        options 
        |> Enum.map(fn 
                %OptionCalc.Option{ type: "Stock"} =    o -> stock_value(value, o.price, o.quantity)
                                                        o -> option_value(value, o.strike, o.price, o.type, o.quantity) end)
        |> Enum.reduce(&+/2)
    end
    
    
    def option_value(_, _, _, _, quantity) when quantity == 0, do: 0
    
    #call buy ITM
    def option_value(value, strike, price, "Call", quantity) when quantity > 0 and value > strike do
        (value - strike - price) * quantity
    end
    
    #put buy ITM
    def option_value(value, strike, price, "Put", quantity) when quantity > 0 and value < strike do
        (strike - value - price) * quantity
    end
    
    #call/put buy OTM
    def option_value(_value, _strike, price, _type, quantity) when quantity > 0 do
        -1 * price * quantity
    end

    #call/put sell ITM/Otm
    def option_value(value, strike, price, type, quantity) when quantity < 0 do
        -1 * option_value(value, strike, price, type, -1 * quantity)
    end

    def stock_value(value, price, quantity), do: (value - price) * quantity
end
