# frozen_string_literal: true

require 'telegram/bot'
require 'set'
require 'faraday/excon'
require_relative '../../lib/term'
require_relative '../../lib/expr'
require_relative 'inline_keyboard_message'

$stdout.sync = true
$stderr.sync = true

HELP_MESSAGE = "
\`/expr <выражение>\` задать выражение
\`/diff <переменная>\` продифференциировать по заданной переменной
"

token = ENV['TELEGRAM_TOKEN']
proxy_url = ENV['TELEGRAM_PROXY']

last_expressions = {}
last_messages = {}

Telegram::Bot.configure do |config|
  config.adapter = :excon
  config.adapter_options = { socks5_proxy: proxy_url }
end

puts 'Starting bot'
Telegram::Bot::Client.run(token) do |bot|
  puts 'Bot started'
  puts "Proxy #{proxy_url}"

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::CallbackQuery
      puts "data #{message.data}"

      case message.data
      when %r{^/diff (.+)}
        expr = last_expressions[message.from.id].diff(
          Regexp.last_match(1).downcase! || Regexp.last_match(1)
        )
        last_expressions[message.from.id] = expr
        last_message = last_messages[message.from.id]

        current_message = response_with_available_variables(bot, expr, message.from.id, last_message&.message_id)
        last_messages[message.from.id] = current_message

      else
        # type code here
      end

    when Telegram::Bot::Types::Message
      puts "message #{message.text}"

      case message.text
      when '/start'
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Привет, #{message.from.first_name}\nУзнать что я умею: /help"
        )

      when '/help'
        bot.api.send_message(
          chat_id: message.chat.id,
          text: HELP_MESSAGE,
          parse_mode: 'Markdown'
        )

      when %r{^/diff (.+)}
        expr = last_expressions[message.from.id].diff(
          Regexp.last_match(1).downcase! || Regexp.last_match(1)
        )
        last_expressions[message.from.id] = expr
        last_message = last_messages[message.from.id]

        bot.api.delete_message(
          chat_id: message.chat.id,
          message_id: message.message_id
        )

        current_message = response_with_available_variables(bot, expr, message.from.id, last_message&.message_id)
        last_messages[message.from.id] = current_message

      when %r{^/expr (.*)}
        expr = Expr.new(
          Regexp.last_match(1).downcase! || Regexp.last_match(1)
        )
        last_expressions[message.from.id] = expr

        last_message = last_messages[message.from.id]

        bot.api.delete_message(
          chat_id: message.chat.id,
          message_id: message.message_id
        )

        unless last_message.nil?
          bot.api.delete_message(
            chat_id: message.chat.id,
            message_id: last_message.message_id
          )
        end

        current_message = response_with_available_variables(bot, expr, message.from.id, nil)
        last_messages[message.from.id] = current_message

      else
        bot.api.send_message(
          chat_id: message.chat.id,
          text: 'Неизвестная команда'
        )
      end
    else
      # type code here
    end

  rescue StandardError => e
    puts e
    puts e.message
    puts e.backtrace
  end
end
