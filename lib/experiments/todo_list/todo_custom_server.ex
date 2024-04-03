# defmodule TodoList.AnotherServer do
#   def start, do: TodoList.CustomServer.start(TodoList.AnotherServer)

#   def init, do: %TodoList{}

#   def cast({:create, todo}, state), do: TodoList.add_entry(state, todo)
#   def cast({:update, id, updater}, state), do: TodoList.update_entry(state, id, updater)
#   def cast({:delete, id}, state), do: TodoList.delete_entry(state, id)
#   def call({:read, date}, state), do: {TodoList.entries(state, date), state}

#   def add(entry), do: TodoList.CustomServer.cast({:create, entry})

#   def entries(date), do: TodoList.CustomServer.call({:read, date})

#   def update(id, updater), do: TodoList.CustomServer.cast({:update, id, updater})

#   def delete(id), do: TodoList.CustomServer.cast({:delete, id})
# end

# defmodule TodoList.CustomServer do
#   def start(module) do
#     spawn(fn ->
#       Process.register(self(), :todolist_server)
#       state = module.init()
#       loop(module, state)
#     end)
#   end

#   def call(request) do
#     send(:todolist_server, {:call, request, self()})

#     receive do
#       {:response, response} -> response
#     end
#   end

#   def cast(request), do: send(:todolist_server, {:cast, request})

#   defp loop(module, state) do
#     new_state =
#       receive do
#         {:cast, request} ->
#           module.cast(request, state)

#         {:call, request, caller} ->
#           {response, new_state} = module.call(request, state)
#           send(caller, {:response, response})
#           new_state
#       end

#     loop(module, new_state)
#   end
# end
