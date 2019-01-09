# JSON Playground

This project was created as a proof of concept to work with dynamic fields that
are stored in a JSON at the database level.

## Use case

We have a Rails model, that can vary its fields in each record on the database, and because of this,
we can't define hardcoded fields on the model (or concerns), and neither on the view level.

These dynamic fields are stored in a MySQL JSON field (or JSONB if using PostgreSQL), and we
will validate them through another JSON field, that has the schema for it (using [json-schema](https://json-schema.org)).

Our inspirations for this are the following resources:
https://apidock.com/rails/ActiveRecord/Store/ClassMethods/store_accessor
https://www.mariocarrion.com/2017/06/06/rails-5-json-array-fields.html
https://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails
http://jetrockets.pro/blog/rails-5-attributes-api-value-objects-and-jsonb
https://blog.codeship.com/unleash-the-power-of-storing-json-in-postgres/

## Commands

To run: `docker-compose up`

To restart the server: `docker-compose exec web pumactl -F config/puma.rb -P tmp/puma.pid restart`

To enter the container: `docker-compose exec web bash`

To run the tests in the the container, use `RAILS_ENV=test rails db:create db:migrate` for the first time. Then you can run `rails test`.

## Notes

- figure out why Rails is calling load and dump multiple times
