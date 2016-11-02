defmodule OptionCalc.Services.OptionDataCache do
  
  @option_repo Application.get_env(:option_calc, :option_repo)
  @timeout 10*60*60
	
  def start_link do
	  Agent.start_link(fn-> %{ } end)
  end

  def get_expirations(pid, symbol) do
    get_value(pid, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_expirations_async(pid, symbol) do
    get_value_async(pid, {:expirations, symbol}, fn {:expirations, symbol} -> @option_repo.read_expirations(symbol) |> Task.await end)
  end

  def get_strike_prices(pid, symbol, date) do
    get_value(pid, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def get_strike_prices_async(pid, symbol, date) do
    get_value_async(pid, {:strikes, symbol, date}, fn {:strikes, symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def set_expirations(pid, symbol, value) do
    set_value(pid, {:expirations, symbol}, value)
  end

  def set_strike_prices(pid, symbol, date, value) do
    set_value(pid, {:strikes, symbol, date}, value)
  end

  def get_value_async(pid, key, query) do
    cached = Agent.get(pid, fn x -> x[key] end)

    if cached != nil && is_valid(cached) do
      Task.async(fn -> cached.value end)
    else
      Task.async(fn ->
        result = Agent.get_and_update(pid, fn x -> { query.(key), x } end) #blocks other request to agent pid so other processes don't call the query function
        set_value(pid, key, result)
        result
      end)
    end
  end

  def get_value(pid, key, query) do
    Agent.get_and_update(pid, fn cache -> 
      if cached = cache[key] do
        { cached.value, cache }
      else
        result = query.(key)
        cached_value = %{ value: result, cached_on: DateTime.utc_now, status: :ready }
        { result, Map.put(cache, key, cached_value) }
      end
    end)
  end

  def set_value(pid, key, value) do
    cached_value = %{ value: value, cached_on: DateTime.utc_now, status: :ready }
    Agent.update(pid, fn state -> Map.put(state, key, cached_value) end)
  end

  def is_valid(cached_data) do
    cached_on = cached_data.cached_on |> DateTime.to_unix
    cached_on + @timeout > DateTime.utc_now |> DateTime.to_unix
  end

end