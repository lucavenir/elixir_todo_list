defmodule Todo.Web do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  put "/todo" do
    IO.puts("PUT /todo started")
    conn = Plug.Conn.fetch_query_params(conn)

    with {:ok, name} <- Map.fetch(conn.params, "name"),
         {:ok, title} <- Map.fetch(conn.params, "title"),
         {:ok, string_date} <- Map.fetch(conn.params, "date"),
         {:ok, date} <- Date.from_iso8601(string_date) do
      name
      |> Todo.Cache.get()
      |> Todo.Server.add(%{title: title, date: date})

      conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(200, "OK\n")
    end

    IO.puts("PUT /todo done")
  end

  get "/todo" do
    IO.puts("GET /todo started")
    conn = Plug.Conn.fetch_query_params(conn)

    with {:ok, name} <- Map.fetch(conn.params, "name"),
         {:ok, string_date} <- Map.fetch(conn.params, "date"),
         {:ok, date} <- Date.from_iso8601(string_date) do
      IO.inspect(date, label: "date")

      entries =
        name
        |> Todo.Cache.get()
        |> Todo.Server.entries(date)

      formatted =
        entries
        |> IO.inspect(label: "entries")
        |> Stream.map(&"#{&1.date} - #{&1.title}")
        |> Enum.join("\n")
        |> then(&(&1 <> "\n"))
        |> IO.inspect(label: "Formatted")

      conn
      |> Plug.Conn.put_resp_content_type("text/plain")
      |> Plug.Conn.send_resp(200, formatted)
    end

    IO.puts("GET /todo done")
  end

  def child_spec(_arg) do
    port = Application.fetch_env!(:todo, :http_port)
    IO.puts("Starting Todo.Web on port #{port}")

    Plug.Cowboy.child_spec(
      scheme: :http,
      options: [port: port],
      plug: __MODULE__
    )
  end
end
