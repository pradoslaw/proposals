Code.compile_file("../../0004-wire-protocol/prototype/codec.exs", __DIR__)

defmodule ARB do
  defmodule R do
    use GenServer

    @impl true
    def init(options), do: {:ok, options}

    @impl true
    def handle_call(m = {:send, address, message},  _from, state) do
      IO.puts "#{state.name}: #{inspect m}"
      GenServer.call(address, message)
      {:reply, :ok, state}
    end

    def handle_call(m, _from, state) do
      IO.puts "#{state.name}: #{inspect m}"
      {:reply, :ok, state}
    end
  end

  defmodule A do
    use GenServer

    @impl true
    def init(options), do: {:ok, options}
  end

  defmodule B do
    use GenServer

    @impl true
    def init(options), do: {:ok, options}

    @impl true
    def handle_call(message, _from, state) do
      IO.puts "#{state.name}: #{inspect message}"
      {:reply, :ok, state}
    end
  end

  def run do
    {:ok, r1} = GenServer.start_link(R, %{name: "r1"})
    {:ok, r2} = GenServer.start_link(R, %{name: "r2"})
    {:ok, r3} = GenServer.start_link(R, %{name: "r3"})
    {:ok, b} = GenServer.start_link(B, %{name: "b"})

    :ok = GenServer.call(r1, {:send, r2, {:send, r3, {:send, b, Ockam.Wire.encode_message(%Ockam.Message.Ping{})}}})
  end

end

ARB.run
