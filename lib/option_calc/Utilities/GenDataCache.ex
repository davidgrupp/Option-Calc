defmodule OptionCalc.Utilities.GenDataCache do
  
  defmacro __using__([timeout: timeout]) do
    quote location: :keep do
        @timeout unquote(timeout) 

        def start_link() do
            Agent.start_link(fn-> %{ } end, name: __MODULE__)
        end

        def get_value_async(process, key, query) do
            cached = Agent.get(process, fn x -> x[key] end)

            if cached != nil && is_valid(cached) do
                Task.async(fn -> cached.value end)
            else
                Task.async(fn ->
                    #Agent.get_and_update blocks other request to agent process so other processes don't call the query function
                    #get_value will check again if the value is in the cache in the case where race conditions got to this branch
                    get_value(process, key, query) 
                end)
            end
        end

        def get_value(process, key, query) do
            Agent.get_and_update(process, fn cache -> 
                if cached = cache[key] do
                    { cached.value, cache }
                else
                    result = query.(key)
                    cached_value = %{ value: result, cached_on: DateTime.utc_now, status: :ready }
                    { result, Map.put(cache, key, cached_value) }
                end
            end)
        end

        def set_value(process, key, value) do
            cached_value = %{ value: value, cached_on: DateTime.utc_now, status: :ready }
            Agent.update(process, fn state -> Map.put(state, key, cached_value) end)
        end

        def is_valid(cached_data) do
            cached_on = cached_data.cached_on |> DateTime.to_unix
            cached_on + @timeout > DateTime.utc_now |> DateTime.to_unix
        end
    end
  end

end