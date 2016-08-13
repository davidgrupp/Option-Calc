defmodule OptioncalcTest do
  use ExUnit.Case
  #doctest OptionCalc.Calc

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
    #sold calls
    assert OptionCalc.Calc.stock_value(0, 100, -1) == 100
    assert OptionCalc.Calc.stock_value(100, 100, -1) == 0
    assert OptionCalc.Calc.stock_value(120, 100, -1) == -20

  end
end
