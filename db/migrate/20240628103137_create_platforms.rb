# frozen_string_literal: true

class CreatePlatforms < ActiveRecord::Migration[7.1]
  def change
    create_table :platforms do |t|
      t.string :name, index: { unique: true, name: 'unique platform name' }
      t.string :abbreviation
      t.string :slug, index: { unique: true, name: 'unique platform slug' }
      t.integer :igdb_id, null: false, index: { unique: true, name: 'unique platform igdb_id' }
      t.belongs_to :platform_family, foreign_key: true

      t.timestamps
    end
  end
end
