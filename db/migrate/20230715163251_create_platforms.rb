class CreatePlatforms < ActiveRecord::Migration[7.0]
  def change
    create_table :platforms do |t|
      t.string :name, null: false, index: { unique: true, name: 'unique platform name index' }
      t.string :abbreviation
      t.integer :igdb_id, index: { unique: true, name: 'unique platform IGDB ID index' }
      t.belongs_to :platform_family, foreign_key: true

      t.timestamps
    end
  end
end
