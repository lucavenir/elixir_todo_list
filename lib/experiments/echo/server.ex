defmodule Echo.Server do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(id))
  end

  def call(id, msg) do
    GenServer.call(via_tuple(id), {:echo, msg})
  end

  def handle_call({:echo, msg}, _, state) do
    {:reply, msg, state}
  end

  def init(_), do: {:ok, nil}

  defp via_tuple(id) do
    {:via, Registry, {:echo_registry, {__MODULE__, id}}}
  end
end

Registry.start_link(name: :echo_registry, keys: :unique)
