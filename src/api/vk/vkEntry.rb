require "vk_longpoll_bot"
require_relative '../../lib/expr.rb'
include VkLongpollBot

$stdout.sync = true
$stderr.sync = true

String token = ENV['VK_TOKEN']
String groupId = ENV['GROUP_ID']

KEYBOARD =
  {
    one_time: false,
    buttons: [
      [
        {
          action: {
            type: "text",
            payload: { button: 1 },
            label: "-"
          },
          color: "negative"
        },
        {
          action: {
            type: "text",
            payload: { button: 2 },
            label: "+"
          },
          color: "negative"
        },
        {
          action: {
            type: "text",
            payload: { button: 3 },
            label: "="
          },
          color: "positive"
        }
      ],
      [{
         action:
           {
             type: "text",
             payload: { button: 1 },
             label: "очистить",
           },
         color: "primary"
       }],
      [{
         action: {
           type: "text",
           payload: { button: 1 },
           label: "показать",
         },
         color: "secondary"
       }]
    ]
  }

class UserSession
  attr_accessor :expression, :status

  def initialize(line = nil)
    if line.nil? || line.empty?
      @expression = nil
    else
      @expression = Expr.new(line)
    end
    @status = 0   # 0 – ожидание команды, 1 – ждём терм для +, 2 – ждём терм для -, 3 – ждём переменную для диф.
  end

  def expression_to_s
    @expression ? @expression.to_s : ""
  end

  def add_term(term)
    if @expression.nil?
      @expression = Expr.new(term)
    else
      @expression = @expression + term
    end
  end

  def subtract_term(term)
    if @expression.nil?
      @expression = Expr.new(term)
    else
      @expression = @expression - term
    end
  end

  def differentiate(var)
    return "Выражение пусто" if @expression.nil?
    @expression = @expression.diff(var)
    nil
  end

  def clear
    @expression = nil
  end

end




user_sessions = {}

bot = Bot.new(token, groupId.to_i)
bot.on_start { puts "✅ Бот запущен" }
bot.on_finish { puts "🛑 Бот остановлен" }

bot.on(subtype: "message_new") do |event|

  user = event["message"]["from_id"]
  msg = event["message"]["text"].to_s.strip

  if ['/stop', '\stop', "stop", "остановись", "стой", "стоп"].include? msg.downcase

    puts "got stop message from #{user} at #{Time.now}"
    bot.send_message(user, "Не хочу умирать!!!!")
    bot.stop
    next
  end

  if ["\\start", "/start", "start", "начало", "начали", "старт", "начать", "привет"].include? msg.downcase

    puts "got start message from #{user} at #{Time.now}"
    bot.send_message(user, "Привет, я могу помочь с простым дифференцированием. Например: напиши x^2 + 3x")
    next
  end

  if ["\help", "\help", "help", "помоги", "помощь"].include? msg.downcase

    puts "got help message from #{user} at #{Time.now}"
    bot.send_message(user, "Я могу тебе помочь с простым дифференцированием уравнений\nНа даннный момент я поддерживаю только ПРОСТЫЕ дифференцируемы члены выражения\nНапример: напиши x^2 + 3x")
    next
  end

  session = user_sessions[user] ||= UserSession.new()
  puts "Сообщение от #{user}: '#{msg}' (статус #{session.status})"

  case session.status
  when 1 # ожидание терма для сложения
    if msg.split.size != 1
      bot.send_message(user, "❌ Ошибка: напишите один терм (например, 2x^2)")
    else
      session.add_term(msg)
      bot.send_message(user, "✅ Добавлено. Текущее выражение: #{session.expression_to_s}", {}, KEYBOARD)
      session.status = 0
    end

  when 2 # ожидание терма для вычитания
    if msg.split.size != 1
      bot.send_message(user, "❌ Ошибка: напишите один терм (например, 2x^2)")
    else
      session.subtract_term(msg)
      bot.send_message(user, "✅ Вычтено. Текущее выражение: #{session.expression_to_s}", {}, KEYBOARD)
      session.status = 0
    end

  when 3 # ожидание переменной для дифференцирования
    if msg.match?(/^[a-zA-Z]$/)
      error = session.differentiate(msg)
      if error
        bot.send_message(user, error, {}, KEYBOARD)
      else
        bot.send_message(user, "📐 Производная: #{session.expression_to_s}", {}, KEYBOARD)
      end
      session.status = 0
    else
      bot.send_message(user, "❌ Переменная должна быть одной буквой (x, y, …)")
    end

  else # status == 0 – ожидание команды или нового выражения
    case msg
    when "+"
      if session.expression.nil?
        bot.send_message(user, "Сначала введите выражение (например, x^2 + 3x)")
      else
        bot.send_message(user, "➕ Напишите терм, который хотите добавить (например, 2x^2)")
        session.status = 1
      end

    when "-"
      if session.expression.nil?
        bot.send_message(user, "Сначала введите выражение")
      else
        bot.send_message(user, "➖ Напишите терм, который хотите вычесть")
        session.status = 2
      end

    when "="
      if session.expression.nil?
        bot.send_message(user, "Сначала введите выражение")
      else
        bot.send_message(user, "📌 По какой переменной дифференцировать? (x, y, …)")
        session.status = 3
      end

    when "очистить"
      session.clear
      bot.send_message(user, "🧹 Выражение очищено. Введите новое", {}, KEYBOARD)

    when "показать"
      if session.expression.nil?
        bot.send_message(user, "📭 Выражение пусто")
      else
        bot.send_message(user, "📄 Ваше выражение: #{session.expression_to_s}", {}, KEYBOARD)
      end

    else
      # Попытка распознать математическое выражение
      if msg.match?(/[+-]?(?:\d*[a-zA-Z](?:\^[+-]?\d+)?|\d+)/)
        session.clear
        session = UserSession.new(msg)   # пересоздаём с новым выражением
        user_sessions[user] = session
        bot.send_message(user, "📝 Выражение сохранено: #{session.expression_to_s}\nВыберите действие", {}, KEYBOARD)
      else
        bot.send_message(user, "🤔 Неизвестная команда. Используйте кнопки или напишите выражение (например, x^2 + 3x)")
      end
    end
  end

  # Если выражение стало пустым после каких-то операций – удаляем сессию
  if session.expression.nil? && session.status == 0
    user_sessions.delete(user)
    bot.send_message(user, "⚡ Выражение удалено. Для начала напишите новое.")
  end
end

bot.run
