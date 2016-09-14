defmodule OptioncalcTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

  test "Calc strategy_profit" do
    options = 
      [%OptionCalc.Option{strike: 100, price: 12.8216, type: "Call", quantity: 1},
      %OptionCalc.Option{strike: 120, price: 5.9976, type: "Call", quantity: -1}]
    
    assert OptionCalc.Calc.strategy_profit(0, options) == -6.824
    assert OptionCalc.Calc.strategy_profit(100, options) == -6.824
    assert OptionCalc.Calc.strategy_profit(120, options) |> Float.round(3) == 13.176
    assert OptionCalc.Calc.strategy_profit(100000, options) |> Float.round(3) == 13.176
  end

  test "Calc option_value" do
    #zero quantity
    assert OptionCalc.Calc.option_value(100, 100, 1, "Call", 0) == 0
    assert OptionCalc.Calc.option_value(100, 100, 1, "Put", 0) == 0
    #bought calls
    assert OptionCalc.Calc.option_value(0, 100, 12.8216, "Call", 1) == -12.8216
    assert OptionCalc.Calc.option_value(100, 100, 12.8216, "Call", 1) == -12.8216
    assert OptionCalc.Calc.option_value(120, 100, 12.8216, "Call", 1) == 7.1784
    #sold calls
    assert OptionCalc.Calc.option_value(0, 100, 12.8216, "Call", -1) == 12.8216
    assert OptionCalc.Calc.option_value(100, 100, 12.8216, "Call", -1) == 12.8216
    assert OptionCalc.Calc.option_value(120, 100, 12.8216, "Call", -1) == -7.1784
    #bought puts
    assert OptionCalc.Calc.option_value(0, 100, 10.8415, "Put", 1) == 89.1585
    assert OptionCalc.Calc.option_value(100, 100, 10.8415, "Put", 1) == -10.8415
    assert OptionCalc.Calc.option_value(120, 100, 10.8415, "Put", 1) == -10.8415
    #sold puts
    assert OptionCalc.Calc.option_value(0, 100, 10.8415, "Put", -1) == -89.1585
    assert OptionCalc.Calc.option_value(100, 100, 10.8415, "Put", -1) == 10.8415
    assert OptionCalc.Calc.option_value(120, 100, 10.8415, "Put", -1) == 10.8415
  end

  test "Calc stock_value" do
    #zero quantity
    assert OptionCalc.Calc.stock_value(100, 100, 0) == 0
    assert OptionCalc.Calc.stock_value(100, 100, 0) == 0
    #bought calls
    assert OptionCalc.Calc.stock_value(0, 100, 1) == -100
    assert OptionCalc.Calc.stock_value(100, 100, 1) == 0
    assert OptionCalc.Calc.stock_value(120, 100, 1) == 20
    assert OptionCalc.Calc.stock_value(0, 100, 2) == -200
    assert OptionCalc.Calc.stock_value(100, 100, 2) == 0
    assert OptionCalc.Calc.stock_value(120, 100, 2) == 40
    #sold calls
    assert OptionCalc.Calc.stock_value(0, 100, -1) == 100
    assert OptionCalc.Calc.stock_value(100, 100, -1) == 0
    assert OptionCalc.Calc.stock_value(120, 100, -1) == -20
    assert OptionCalc.Calc.stock_value(0, 100, -2) == 200
    assert OptionCalc.Calc.stock_value(100, 100, -2) == 0
    assert OptionCalc.Calc.stock_value(120, 100, -2) == -40

  end
end
