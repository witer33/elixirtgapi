defmodule Tgapi do
  use Tesla, docs: false

  @moduledoc """
  Documentation for `Tgapi`.
  """

  @doc """
  you should use this to call Telegram methods.
  """

  adapter(Tesla.Adapter.Hackney, recv_timeout: 63_000)
  plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org")

  def client(token) do
    fn method ->
      fn parameters ->
        parameters =
          Enum.map_join(parameters, "&", fn param -> "#{elem(param, 0)}=#{elem(param, 1)}" end)

        case get("/bot#{token}/#{method}?#{parameters}") do
          {:ok, %{body: body}} ->
            {:ok, data} = JSON.decode(body)

            case data do
              %{"ok" => true} -> {:ok, data["result"]}
              %{"ok" => false} -> {:error, data}
            end

          {:error, error} ->
            {:error, error}
        end
      end
    end
  end

  def inline_keyboard(data) do
    JSON.encode!(%{inline_keyboard: data})
  end

  def keyboard(data) do
    JSON.encode!(%{keyboard: data})
  end

  def get_updates(token, offset \\ 0) do
    client(token).(:getUpdates).(offset: offset, timeout: 60)
  end

  def handle(token, handler, offset \\ 0) do
    {:ok, updates} = get_updates(token, offset)
    Enum.each(updates, &Task.Supervisor.start_child(Tgapi.TaskSupervisor, fn -> handler.(&1) end))
    last_update_id = Enum.at(updates, -1, %{"update_id" => -1})["update_id"]
    handle(token, handler, last_update_id + 1)
  end

  def spawn_handle(token, handler, offset \\ 0) do
    Task.start_link(fn -> handle(token, handler, offset) end)
  end

  def start(token, handler) do
    Supervisor.start_link([
      {Task.Supervisor, name: Tgapi.TaskSupervisor},
      {Tgapi.Session, Tgapi.BotSession},
      Supervisor.child_spec({Task, fn -> handle(token, handler) end}, restart: :permanent)
    ], [strategy: :one_for_one, name: Tgapi.Supervisor])
  end
end
