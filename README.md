# Tgapi

**Efficient, concurrent and lightweight Telegram Bot API framework written in Elixir**

## Installation

The package can be installed
by adding `tgapi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tgapi, "~> 0.2.0"}
  ]
end
```

## A clean example

```elixir
token = "TOKEN"
botClient = Tgapi.client(token)

Tgapi.start(token, fn update ->
  case update do
    %{"message" => %{"text" => "/start"}} -> 
      botClient.(:sendMessage).(
        chat_id: update["message"]["chat"]["id"],
        text: "helo",
        reply_markup: Tgapi.inline_keyboard([[%{text: "hey", callback_data: "nice"}]])
      )
    
    %{"message" => %{"text" => _}} -> 
      botClient.(:sendMessage).(chat_id: update["message"]["chat"]["id"], text: "?")
    
    _ -> nil
  end
end)

Process.sleep(:infinity)
```

## Storage system

### PUT

Tgapi.Session.put(Tgapi.BotSession, key, value)

### Example

```elixir
Tgapi.Session.put(Tgapi.BotSession, :name, "Alex")
```

### GET

Tgapi.Session.get(Tgapi.BotSession, key)

### Example

```elixir
name = Tgapi.Session.get(Tgapi.BotSession, :name)
```
