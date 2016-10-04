defmodule OptionDataCache do
  use GenServer
  
  @option_repo Application.get_env(:option_calc, :option_repo)

  def get_expirations(pid, symbol), do: GenServer.call(pid,:get_expirations)
  def set_expirations(pid, symbol), do: GenServer.cast(pid,{:set_expirations, symbol})
	
  def start_link(list) do
    GenServer.start_link(__MODULE__, {list, Enum.reverse(list)})
  end
	
  def handle_call(:get_expirations, _from, { [h|t], rlist }) do
    {:reply, h, { t, Enum.drop(rlist, -1) } }
  end



  def handle_cast({:set_expirations, symbol}, { state, rlist }) do
    #{:noreply, { [item|state], rlist++[item] } }
  end



end