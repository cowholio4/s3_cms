# FROM ruby:3.1.2
FROM docker.io/library/ruby:3.1.2@sha256:e75f1da5372940f6997c94c9c48db8e4292fb625ca49035fa53e7e5b9124d6fb  
LABEL maintainer "Jason Pope <cowhololio4@gmail.com>"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# prep for mysql
RUN apt-get update -qq && apt-get install -qq --no-install-recommends  default-mysql-client

# install aws client
RUN curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" > /tmp/awscliv2.zip \
  && unzip /tmp/awscliv2.zip -d /tmp/awscliv2 \
  && /tmp/awscliv2/aws/install && rm -rf /tmp/awscliv2/ /tmp/awscliv2.zip

# install node and yarn
RUN curl -sL https://deb.nodesource.com/setup_17.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
  nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn
RUN yarn set version berry

RUN apt-get update && apt-get install -y netcat

RUN mkdir /code
WORKDIR /code

# COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.3.7
# RUN bundle install

# COPY yarn.lock package.json ./
COPY . .

EXPOSE 3000

ENTRYPOINT ["bash", "./config/docker/entrypoint.sh"]
