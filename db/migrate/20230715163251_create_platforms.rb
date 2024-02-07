class CreatePlatforms < ActiveRecord::Migration[7.0]
  def change
    create_table :platforms do |t|
      t.string :name, index: { unique: true, name: 'unique platform name index' }
      t.string :abbreviation
      t.string :ps_abbreviation
      t.integer :igdb_id, index: { unique: true, name: 'unique platform IGDB ID index' }
      t.string :slug, index: { unique: true, name: 'unique platform slug index' }
      t.belongs_to :platform_family, foreign_key: true

      t.timestamps
    end
  end
end
