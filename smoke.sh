#!/usr/bin/env bash
set -euo pipefail

# Allow overriding the environment (defaults to development)
export RAILS_ENV="${RAILS_ENV:-development}"

rm -f Gemfile.lock

bundle install

bundle exec rails db:drop

bundle exec rails db:create

bundle exec rails db:migrate

bundle exec rails runner "ExampleTap.new.perform"

bundle exec rails runner "ExampleTwoTap.new.perform"
bundle exec rails runner 'begin
  count = Request.count
  classes = Request.distinct.pluck(:extractor_class)
  puts "Requests count: #{count}"
  puts "Extractor classes: #{classes.inspect}"
  exit(count > 0 ? 0 : 1)
rescue => e
  warn "Verification failed: #{e.class}: #{e.message}"
  exit 1
end'
