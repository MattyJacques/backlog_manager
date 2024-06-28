# frozen_string_literal: true

class CreatePlatformFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :platform_families do |t|
      t.string :name, null: false, index: { unique: true, name: 'unique platform_family name' }
      t.string :slug, index: { unique: true, name: 'unique platform_family slug' }
      t.integer :igdb_id, null: false, index: { unique: true, name: 'unique platform_family igdb_id' }

      t.timestamps
    end
  end
end
