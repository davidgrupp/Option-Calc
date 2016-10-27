defmodule OptionCalc.Services.OptionDataCache do
  
  @option_repo Application.get_env(:option_calc, :option_repo)
  @timeout 10*60*60
	
  def start_link do
	  Agent.start_link(fn-> %{ expirations: %{}, strikes: %{} } end)
  end

  def get_expirations(pid, symbol) do
    Agent.get_and_update(pid, fn %{ expirations: cache } = state -> 
      if cached = cache[symbol] do
        { cached, cache }
      else
        result = @option_repo.read_expirations(symbol) |> Task.await
        { result, Map.put(state, :expirations, Map.put(cache, symbol, result)) }
      end
    end)
  end

  def get_expirations_async(pid, symbol) do
    cache = Agent.get(pid, fn %{ expirations: exp_cache } -> exp_cache end)
    cached = cache[symbol]

    if cached != nil && is_valid(cached) do
      Task.async(fn -> cached.value end)
    else
      Task.async(fn ->
        exp = @option_repo.read_expirations(symbol) |> Task.await
        set_expirations(pid, symbol, exp)
        exp
      end)
    end
  end


  def get_strikes_prices_async(pid, symbol, date) do
    get_value_async(pid, :strikes, {symbol, date}, fn {symbol, date} -> @option_repo.read_strike_prices(symbol, date) |> Task.await end)
  end

  def get_value_async(pid, section, key, query) do
    cache = Agent.get(pid, fn x -> x[section] end)
    cached = cache[key]

    if cached != nil && is_valid(cached) do
      Task.async(fn -> cached.value end)
    else
      Task.async(fn ->
        exp = query.(key)
        set_value(pid, section, key, exp)
        exp
      end)
    end
  end

  def get_value(pid, section key) do
    Agent.get_and_update(pid, fn cache -> 
      if cached = cache[section][symbol] do
        { cached, cache }
      else
        result = @option_repo.read_expirations(symbol) |> Task.await
        { result, Map.put(state, :expirations, Map.put(cache, symbol, result)) }
      end
    end)
  end

  def set_expirations(pid, symbol, value) do
    cached_value = %{ value: value, cached_on: DateTime.utc_now, status: :ready }
    Agent.update(pid, fn %{ expirations: exp } = state -> Map.put(state, :expirations, Map.put(exp, symbol, cached_value )) end)
  end

  def set_strikes_prices(pid, symbol, date, value) do
    cached_value = %{ value: value, cached_on: DateTime.utc_now, status: :ready }
    Agent.update(pid, fn %{ strikes: str } = state -> Map.put(state, :strikes, Map.put(str, {symbol, date}, cached_value )) end)
  end

  def set_value(pid, section, key, value) do
    cached_value = %{ value: value, cached_on: DateTime.utc_now, status: :ready }
    Agent.update(pid, fn state -> Map.put(state, section, Map.put(state[section], key, cached_value )) end)
  end

  def is_valid(cached_data) do
    cached_on = cached_data.cached_on |> DateTime.to_unix
    cached_on + @timeout > DateTime.utc_now |> DateTime.to_unix
  end

end