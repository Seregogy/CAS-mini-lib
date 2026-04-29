# frozen_string_literal: true

require_relative 'message_send_strategy'

def response_with_available_variables(bot, expr, chat_id, last_message_id)
  variables = parse_variables(expr)
  send_strategy = last_message_id.nil? ? SendNewMessage.new : EditLastMessage.new

  case variables.size
  when 0
    send_strategy.send(
      bot,
      chat_id,
      "\`#{expr}\`",
      last_message_id
    )
  when 1
    send_strategy.send(
      bot,
      chat_id,
      "\`#{expr}\`",
      last_message_id,
      [ButtonCommand.new('Продифференциировать', "/diff #{variables.first}")]
    )
  else
    send_strategy.send(
      bot,
      chat_id,
      "\`#{expr}\`\nПродифференциировать по переменной..",
      last_message_id,
      variables.map do |variable|
        ButtonCommand.new(variable.to_s, "/diff #{variable}")
      end
    )
  end
end

def parse_variables(expr)
  variables = Set.new

  expr.to_s.scan(/[a-zA-Z]/) do |variable|
    next if variable.empty?

    variables << variable
  end

  variables
end
