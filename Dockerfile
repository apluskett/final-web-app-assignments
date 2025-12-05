# syntax=docker/dockerfile:1
# check=skip=SecretsUsedInArgOrEnvInstructions

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t assignment_3 .
# docker run -d -p 3000:3000 -e RAILS_MASTER_KEY=<value from config/master.key> --name assignment_3 assignment_3

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages including Node.js and npm
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 ca-certificates gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" \
    SECRET_KEY_BASE="dummy-key-for-build"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JavaScript dependencies and build
COPY package.json package-lock.json ./
RUN npm install && npm run build

# Copy built assets to public directory for direct serving
RUN mkdir -p public/assets/builds && \
    cp -r app/assets/builds/* public/assets/builds/

# Generate a new master key and credentials file for this container build
# This allows anyone to build and run without needing the original master.key
RUN rm -f config/master.key config/credentials.yml.enc && \
    EDITOR="echo '# Add secrets here' >" bundle exec rails credentials:edit

# Precompile Rails assets (CSS, JS) for production
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Ensure all bin scripts are executable to prevent permission denied errors
RUN chmod +x ./bin/rails ./bin/thrust ./bin/docker-entrypoint




# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails


RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails /rails && \
    chmod +x /rails/bin/rails /rails/bin/thrust /rails/bin/docker-entrypoint && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database. Invoke the script through bash to avoid
# exec failures if the shebang is mangled by CRLF or not present in the image.
ENTRYPOINT ["bash", "/rails/bin/docker-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]