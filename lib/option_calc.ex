defmodule OptionCalc do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    
    nodes = Application.get_env(:option_calc, :nodes)
    # Define workers and child supervisors to be supervised
    children = setup_children(nodes[Node.self])

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OptionCalc.Supervisor]
    
    sup = Supervisor.start_link(children, opts)
    setup_services(nodes)
    sup
  end

  def setup_children(:web) do
    import Supervisor.Spec
    [
      # Start the Ecto repository
      supervisor(OptionCalc.Repo, []),
      # Start the endpoint when the application starts
      supervisor(OptionCalc.Endpoint, []),
      # Start your own worker by calling: OptionCalc.Worker.start_link(arg1, arg2, arg3)
      # worker(OptionCalc.Worker, [arg1, arg2, arg3]),
      worker(OptionCalc.Utilities.ServiceLocator, [])
    ]
  end

  def setup_children(:cache) do
    import Supervisor.Spec
    [
      # Start the Ecto repository
      supervisor(OptionCalc.Repo, []),
      # worker(OptionCalc.Worker, [arg1, arg2, arg3]),
      worker(OptionCalc.Utilities.ServiceLocator, []),
      worker(OptionCalc.Services.QuoteDataCache, []),
      worker(OptionCalc.Services.OptionDataCache, [])
    ]
  end

  def setup_services(nodes) do
    {cache_node, :cache} = nodes |> Enum.find(fn {_,v} -> v == :cache end)
    OptionCalc.Utilities.ServiceLocator.add_service(OptionCalc.Services.QuoteDataCache, cache_node)
    OptionCalc.Utilities.ServiceLocator.add_service(OptionCalc.Services.OptionDataCache, cache_node)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    OptionCalc.Endpoint.config_change(changed, removed)
    :ok
  end
end
