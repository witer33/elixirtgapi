defmodule TgapiTest do
  use ExUnit.Case
  doctest Tgapi
  @moduletag timeout: :infinity

  setup do
    token = "1275427866:AAF4fTKYlPIVYk9yTTkLlnbdDJLmc-OdroA"

    %{token: token}
  end

  test "simple bot", %{token: token} do
    botClient = Tgapi.client(token)

    Tgapi.start(token, fn update ->
      case update do
        %{"message" => %{"text" => "/start"}} ->
          botClient.(:sendMessage).(chat_id: update["message"]["chat"]["id"], text: "helo")

        %{"message" => %{"text" => _}} ->
          botClient.(:sendMessage).(
            chat_id: update["message"]["chat"]["id"],
            text: "?",
            reply_markup: Tgapi.inline_keyboard([[%{text: "ciao", callback_data: "no"}]])
          )

        %{
          "callback_query" => %{
            "id" => id,
            "data" => data,
            "message" => %{"message_id" => messageID, "text" => text, "chat" => %{"id" => chatID}}
          }
        } ->
          botClient.(:answerCallbackQuery).(callback_query_id: id)

          botClient.(:editMessageText).(
            chat_id: chatID,
            message_id: messageID,
            text: data,
            reply_markup: Tgapi.inline_keyboard([[%{text: "ciao", callback_data: text}]])
          )

        _ ->
          nil
      end
    end)
    # Process.sleep(:infinity)
  end

  test "bot with session", %{token: token} do
    botClient = Tgapi.client(token)

    Tgapi.start(token, fn update ->
      case update do
        %{"message" => %{"text" => text}} ->
          previous_text = Tgapi.Session.get(:previous_text)
          Tgapi.Session.put(:previous_text, text)
          botClient.(:sendMessage).(chat_id: update["message"]["chat"]["id"], text: "prev text #{previous_text}")

        _ ->
          nil
      end
    end)

    Process.sleep(:infinity)
  end
end
