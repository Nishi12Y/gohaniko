set -o errexit

bundle install
npm install
npm run build
npm run build:css
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
bundle exec rails db:seed