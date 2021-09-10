defmodule Tgapi.Session do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, %{}, name: name)
  end

  def put(key, value) do
    GenServer.cast(Tgapi.BotSession, {:put, key, value})
  end

  def get(key) do
    GenServer.call(Tgapi.BotSession, {:get, key})
  end

  def delete(key) do
    GenServer.cast(Tgapi.BotSession, {:delete, key})
  end

  @impl true
  def init(%{}) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_cast({:delete, key}, state) do
    {:noreply, Map.delete(state, key)}
  end
end
