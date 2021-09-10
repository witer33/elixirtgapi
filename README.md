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
    %{"message" => %{"text" => "/start", "chat" => %{"id" => chatID}}} -> 
      botClient.(:sendMessage).(
        chat_id: chatID,
        text: "helo",
        reply_markup: Tgapi.inline_keyboard([[%{text: "hey", callback_data: "nice"}]])
      )
    
    %{"message" => %{"text" => _, "chat" => %{"id" => chatID}}} -> 
      botClient.(:sendMessage).(chat_id: chatID, text: "?")
    
    _ -> nil
  end
end)

Process.sleep(:infinity)
```

### Telegram method call

Tgapi.client(token).(:method).(params)

#### Example

```elixir
Tgapi.client("123456789:d2FpdCB3aHkgZGlkIHlvdSBkZWNvZGU").(:sendMessage).(
  chat_id: -348924427,
  text: "how are you?"
)
```

## Storage system

### PUT

Tgapi.Session.put(key, value)

#### Example

```elixir
Tgapi.Session.put(:name, "Alex")
```

### GET

Tgapi.Session.get(key)

#### Example

```elixir
name = Tgapi.Session.get(:name)
```
### DELETE

Tgapi.Session.delete(key)

#### Example

```elixir
Tgapi.Session.delete(:name)
```
