defmodule Todo.Registry do
  def start_link, do: Registry.start_link(name: __MODULE__, keys: :unique)
  def via_tuple(id), do: {:via, Registry, {__MODULE__, id}}

  def child_spec do
    Supervisor.child_spec(Registry, id: __MODULE__, start: {__MODULE__, :start_link, []})
  end
end
