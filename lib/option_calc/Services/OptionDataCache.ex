defmodule OptionCalc.Services.OptionDataCache do
  
  @option_repo Application.get_env(:option_calc, :option_repo)
	
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
    cache = Agent.get(pid, &(&1))
    
    if cached = cache[symbol] do
      Task.async(fn -> cached end)
    else
      Task.async(fn ->
        exp = @option_repo.read_expirations(symbol) |> Task.await
        set_expirations(pid, symbol, exp)
        exp
      end)
    end
  end

  def set_expirations(pid, symbol, value) do
    Agent.update(pid, fn %{ expirations: exp } = state -> Map.put(state, :expirations, Map.put(exp, symbol, value)) end)
  end

end