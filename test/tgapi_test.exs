defmodule TgapiTest do
  use ExUnit.Case
  doctest Tgapi
  @moduletag timeout: :infinity

  test "simple bot" do
    token = "TOKEN"
    botClient = Tgapi.client(token)


    Tgapi.handle(token, fn update ->
      case update do
        %{"message" => %{"text" => "/start"}} -> botClient.(:sendMessage).(chat_id: update["message"]["chat"]["id"], text: "helo")
        %{"message" => %{"text" => _}} -> botClient.(:sendMessage).(chat_id: update["message"]["chat"]["id"],
                                                                           text: "?", reply_markup: Tgapi.inline_keyboard([[%{text: "ciao", callback_data: "no"}]]))
        %{"callback_query" => %{"id" => id, "data" => data, "message" => %{"message_id" => messageID, "text" => text, "chat" => %{"id" => chatID}}}} ->
          botClient.(:answerCallbackQuery).(callback_query_id: id)
          botClient.(:editMessageText).(chat_id: chatID, message_id: messageID, text: data, reply_markup: Tgapi.inline_keyboard([[%{text: "ciao", callback_data: text}]]))
        _ -> nil
      end
    end)
  end
end
