defmodule PlugLogger do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Task, fn ->
        :mnesia.create_schema([node()])
        :mnesia.start

        Log.Base.init
      end},
      Plug.Adapters.Cowboy.child_spec(:http, PlugLogger.Router, [dir: "data"], port: 4000),
      Log.Server.child_spec([]),
    ]

    Logger.info "Started application"

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
