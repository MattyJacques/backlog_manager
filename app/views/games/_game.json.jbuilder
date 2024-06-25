# frozen_string_literal: true

json.extract! game, :id, :name, :created_at, :updated_at, :igdb_id
json.url game_url(game, format: :json)
