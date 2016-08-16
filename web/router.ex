defmodule OptionCalc.Router do
  use OptionCalc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OptionCalc do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/chart", ChartController
  end

  # Other scopes may use custom stacks.
  scope "/api", OptionCalc do
    pipe_through :api

    post "/chart/points", ChartController, :points
  end
end
