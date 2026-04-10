# frozen_string_literal: true

ButtonCommand = Struct.new(:text, :query)

# Стратегия отправки сообщения
class MessageSendStrategy
  # bot: Telegram::Bot
  # chat_id: String
  # message: String
  # last_message_id: String
  # button_commands: Array of ButtonCommand
  def send(bot, chat_id, message, last_message_id, button_commands = []) end
end

# Стратегия отравки нового сообщения
class SendNewMessage < MessageSendStrategy
  def send(bot, chat_id, message, _last_message_id, button_commands = [])
    bot.api.send_message(
      chat_id: chat_id,
      text: message,
      reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [button_commands.map do |command|
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: command.text, callback_data: command.query
          )
        end]
      ),
      parse_mode: 'Markdown'
    )
  end
end

# Стратегия редактирования существующего сообщения
class EditLastMessage < MessageSendStrategy
  def send(bot, chat_id, message, last_message_id, button_commands = [])
    return unless last_message_id
    puts last_message_id

    bot.api.edit_message_text(
      chat_id: chat_id,
      message_id: last_message_id,
      text: message,
      reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [button_commands.map do |command|
          Telegram::Bot::Types::InlineKeyboardButton.new(
            text: command.text, callback_data: command.query
          )
        end]
      ),
      parse_mode: 'Markdown'
    )
  end
end
