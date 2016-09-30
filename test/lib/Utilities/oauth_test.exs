defmodule OAuthTests do
  use ExUnit.Case
  #doctest OptionCalc.OAuth

  test "Chart points" do
    options = 
      [%OptionCalc.Option{strike: 100, price: 12.8216, type: :call, quantity: 1},
      %OptionCalc.Option{strike: 120, price: 5.9976, type: :call, quantity: -1}]
    
    #assert on patern match 
    [{"Authorization", "OAuth oauth_signature=" <> _}] = OptionCalc.OAuth.sign(:get, "https://example.com", :tk_oauth)
    assert true
  end

end
