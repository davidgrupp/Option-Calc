defmodule OptionCalc.PageController do
  use OptionCalc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
