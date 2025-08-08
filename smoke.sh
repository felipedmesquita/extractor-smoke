#!/usr/bin/env bash
set -euo pipefail

# Ensure we run from the app root even if invoked elsewhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

rm -f Gemfile.lock

bundle install

bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate

bundle exec rails runner "ExampleTap.new.perform"
bundle exec rails runner "ExampleTwoTap.new.perform"

bundle exec rails runner 'begin
  blue = "\e[34m"; reset = "\e[0m"
  count = Request.count
  classes = Request.distinct.pluck(:extractor_class)
  puts "Requests count: #{blue}#{count}#{reset}"
  puts "Extractor classes: #{blue}#{classes.inspect}#{reset}"
  exit(count > 0 ? 0 : 1)
rescue => e
  warn "Error: #{e.class}: #{e.message}"
  exit 1
end'
