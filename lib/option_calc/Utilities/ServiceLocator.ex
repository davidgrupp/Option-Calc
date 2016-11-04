defmodule OptionCalc.Utilities.ServiceLocator do
    def start_link, do: Agent.start(fn -> %{} end, name: __MODULE__ )
    def add_service(service, node), do: Agent.update(__MODULE__, &(Map.put(&1, service, node)))
    def get_service(service), do: {service, Agent.get(__MODULE__, &(&1[service]))}

end