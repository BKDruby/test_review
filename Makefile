BACKEND_CONTAINER = web

# Install dependencies using Bundler
bundle:
	docker compose exec $(BACKEND_CONTAINER) bundle install

# Run tests with RSpec
rspec:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rspec $(spec)

t: rspec
r: rspec

# Run database migrations
migrate:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails db:migrate

# Rollback the last migration
rollback:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails db:rollback

# Open the Rails console
console:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails console

c: console

# Start the Rails server inside the container
server:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails server -b 0.0.0.0

# Attach to the backend container's shell
attach:
	docker compose exec $(BACKEND_CONTAINER) bash

# Run a custom Rails command
rails-cmd:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails $(CMD)

# Start all services using Docker Compose
start:
	docker compose up -d

# Stop all services using Docker Compose
stop:
	docker compose down

# Restart all services using Docker Compose
restart:
	docker compose restart

# Rebuild Docker containers
build:
	docker compose build

# Clean up containers, images, and volumes
clean:
	docker compose down --volumes --rmi local --remove-orphans
	docker system prune -af --volumes

# Run seeds
seed:
	docker compose exec $(BACKEND_CONTAINER) bundle exec rails db:seed