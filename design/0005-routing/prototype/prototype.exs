Code.compile_file("../../0004-wire-protocol/prototype/codec.exs", __DIR__)

defmodule Router do
  use GenServer

  def start(name, init_args) do
    GenServer.start_link(Router, Map.put(init_args, :name, name), name: name)
  end

  @impl true
  def init(init_args) do
    {:ok, Map.put_new(init_args, :routing_table, %{})}
  end

  @impl true
  def handle_call(:get_state,  _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:register_route, destination, route}, state) do
    routing_table = Map.put(state.routing_table, destination, route)
    {:noreply, %{state | routing_table: routing_table}}
  end

  @impl true
  def handle_info(m = {:send, destination, message}, state) do
    IO.puts "#{inspect(state.name)}: #{inspect(m)}"

    route = Map.get(state.routing_table, destination)
    if route do
      {:send, next_hop, next_hop_message} = prepare_routed_message({:send, destination, message}, Enum.reverse(route))
      send(next_hop, next_hop_message)
    else
      send(destination, message)
    end

    {:noreply, state}
  end

  def prepare_routed_message(message, []), do: message
  def prepare_routed_message(message, [hop | hops]) do
    prepare_routed_message({:send, hop, message}, hops)
  end

end

defmodule B do
  use GenServer

  def start(init_args) do
    GenServer.start_link(B, Map.put(init_args, :name, B), name: B)
  end

  @impl true
  def init(init_args), do: {:ok, init_args}

  @impl true
  def handle_info(message, state) do
    {m, _} = Ockam.Wire.decode_message(message)
    IO.puts "#{inspect(state.name)}: #{inspect(m)}"
    {:noreply, state}
  end
end

defmodule A do
  use GenServer

  def start(init_args) do
    GenServer.start_link(A, Map.put(init_args, :name, A), name: A)
  end
  @impl true
  def init(init_args) do
    {:ok, Map.put_new(init_args, :routing_table, %{})}
  end

  @impl true
  def handle_call(:get_state,  _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:register_route, destination, route}, state) do
    routing_table = Map.put(state.routing_table, destination, route)
    {:noreply, %{state | routing_table: routing_table}}
  end

  @impl true
  def handle_info(m = {:send, destination, message}, state) do
    IO.puts "#{inspect(state.name)}: #{inspect(m)}"

    route = Map.get(state.routing_table, destination)
    if route do
      {:send, next_hop, next_hop_message} = prepare_routed_message({:send, destination, message}, Enum.reverse(route))
      send(next_hop, next_hop_message)
    else
      send(destination, message)
    end

    {:noreply, state}
  end

  def prepare_routed_message(message, []), do: message
  def prepare_routed_message(message, [hop | hops]) do
    prepare_routed_message({:send, hop, message}, hops)
  end
end


defmodule ARB do
  def run do
    {:ok, _} = Router.start(R1, %{})
    {:ok, _} = Router.start(R2, %{})
    {:ok, _} = Router.start(R3, %{})
    {:ok, _} = Router.start(R4, %{})
    {:ok, _} = Router.start(R5, %{})

    {:ok, _} = B.start(%{})

    {:ok, _} = A.start(%{
      routing_table: %{
        B => [R1, R2, R3, R4, R5]
      }
    })

    send A, {:send, B, Ockam.Wire.encode_message(%Ockam.Message.Ping{})}
  end
end
