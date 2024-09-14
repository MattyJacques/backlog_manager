# frozen_string_literal: true

class CreateGameStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :game_statuses do |t|
      t.integer :status, null: false
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
