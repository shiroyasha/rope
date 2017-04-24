FROM ruby:2.2-slim

RUN gem install rope-server

ADD app.rb app.rb
ADD service.yml service.yml

CMD rope app.rb --bind 0.0.0.0 --port 80
