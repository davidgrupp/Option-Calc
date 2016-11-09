defmodule OAuthTests do
  use ExUnit.Case
  #doctest OptionCalc.OAuth

  test "OAuth sign" do
    #assert on patern match 
    assert [{"Authorization", "OAuth oauth_signature=" <> _}] = OptionCalc.OAuth.sign(:get, "https://example.com", :tk_oauth)
    #assert 1==1
  end

end
