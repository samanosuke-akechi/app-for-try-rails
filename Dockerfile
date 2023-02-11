FROM ruby:3.1.2
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    nodejs \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /app-for-try-rails

WORKDIR /app-for-try-rails

COPY Gemfile /app-for-try-rails/Gemfile
COPY Gemfile.lock /app-for-try-rails/Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /app-for-try-rails

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
