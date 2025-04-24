
# Exit on error
set -o errexit

bundle install
bundle exec rails db:prepare
bundle exec rails db:migrate
