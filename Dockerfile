FROM ruby:3.4-slim

WORKDIR /app

RUN apt-get update -qq && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY src/Gemfile ./
RUN bundle install

COPY . .

CMD ["ruby", "src/api/tg/tg_entry.rb"]
