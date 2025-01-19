FROM ruby:3.3.6

# Update and install necessary packages
RUN apt-get update -qq && apt-get install -y \
  postgresql-client \
  nodejs \
  wget \
  curl \
  gnupg2 \
  ca-certificates \
  unzip \
  libnss3 \
  libdbus-1-3 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libxkbcommon0 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libasound2 \
  fontconfig && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarnkey.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn && \
  rm -rf /var/lib/apt/lists/*

# Install Google Chrome version 132
RUN wget https://storage.googleapis.com/chrome-for-testing-public/132.0.6834.83/linux64/chrome-linux64.zip -O /tmp/chrome-linux64.zip && \
    unzip /tmp/chrome-linux64.zip -d /opt/ && \
    ln -s /opt/chrome-linux64/chrome /usr/local/bin/google-chrome-stable && \
    rm -rf /tmp/chrome-linux64.zip

# Install ChromeDriver version 132
RUN wget  https://storage.googleapis.com/chrome-for-testing-public/132.0.6834.83/linux64/chromedriver-linux64.zip -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /opt/ && \
    mv /opt/chromedriver-linux64/chromedriver /opt/ && \
    rm -rf /opt/chromedriver-linux64 && \
    ln -s /opt/chromedriver /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver.zip

# Set working directory
WORKDIR /app

# Copy Gemfile and install Ruby gems
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Copy the rest of the application files
COPY . /app

RUN yarn install

# Expose port 3000 for Rails server
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]