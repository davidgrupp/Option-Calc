defmodule OptionCalc.Services.OptionDataCache do
  use GenServer
  
  @option_repo Application.get_env(:option_calc, :option_repo)

  def get_expirations(pid, symbol), do: GenServer.call(pid,{:get_expirations, symbol})
  def set_expirations(pid, symbol), do: GenServer.cast(pid,{:set_expirations, symbol})
	
  def start_link() do
    GenServer.start_link(__MODULE__, %{ expirations: %{}, strikes: %{} })
  end
	
  def handle_call({:get_expirations, symbol}, _from, %{ expirations: expirations} = state) do
    if Map.has_key?(expirations, symbol) && expirations[symbol].date > 10minutes do

    else

    end
    exp_tsk = @option_repo.read_expirations(symbol)
    tsk = Task.async(fn ->
      exp = exp_tsk |> Task.await
      push_expiration(%{symbol: symbol, expirations: exp})
      exp
    end)
    {:reply, tsk, { } }
  end
  
  def handle_call({:get_expirations, symbol}, _from, %{ expirations: expirations} = state) do
    exp_tsk = @option_repo.read_expirations(symbol)
    tsk = Task.async(fn ->
      exp = exp_tsk |> Task.await
      push_expiration(%{symbol: symbol, expirations: exp})
      exp
    end)
    { :reply, tsk, state }
  end



  def handle_cast({:set_expirations, symbol}, { state, rlist }) do
    #{:noreply, { [item|state], rlist++[item] } }
  end



end