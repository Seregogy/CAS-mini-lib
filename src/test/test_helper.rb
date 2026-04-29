require 'simplecov'

SimpleCov.start do
  #add_filter '/test/'          # исключаем сами тесты из отчёта
  add_filter '/vendor/'        # исключаем сторонние библиотеки
  enable_coverage :branch      # учитываем покрытие ветвлений (опционально)
end

require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
                           Minitest::Reporters::HtmlReporter.new(reports_dir: 'coverage/html'), # для HTML отчёта
                           Minitest::Reporters::ProgressReporter.new,                           # прогресс в консоли
                         ]
