# syntax=docker/dockerfile:1

# Use the official Ruby image with version 3.2.0
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  npm \
  default-mysql-client \
  libssl-dev \
  libreadline-dev \
  zlib1g-dev \
  build-essential \
  curl

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc

# Install the specified Ruby version using rbenv
ENV PATH="/root/.rbenv/bin:/root/.rbenv/shims:$PATH"
RUN rbenv install 3.3.0 && rbenv global 3.3.0

# Set the working directory
RUN mkdir /inspira
WORKDIR /inspira

# Copy the Gemfile and Gemfile.lock
COPY /inspira/Gemfile /inspira/Gemfile
COPY /inspira/Gemfile.lock /inspira/Gemfile.lock

# Install Gems dependencies
RUN gem install bundler && bundle install

# Copie o package.json e o yarn.lock para o diretório de trabalho
COPY /inspira/package.json /inspira/package.json
COPY /inspira/package-lock.json /inspira/package-lock.json
COPY /inspira/yarn.lock /inspira/yarn.lock

# Instale as dependências do JavaScript
RUN npm install --global yarn

# Atualize o caniuse-lite
# RUN npx update-browserslist-db@latest

# Copy the application code
COPY /inspira /inspira

# Precompile assets (optional, if using Rails with assets)
# RUN bundle exec rake assets:precompile

# Expose the port the app runs on
EXPOSE 3000

# Command to run the server
CMD ["rails", "server", "-b", "0.0.0.0"]