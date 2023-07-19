class CreatePlatformFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_families do |t|
      t.string :name, null: false, index: { unique: true, name: 'unique family name index' }
      t.integer :igdb_id, index: { unique: true, name: 'unique family IGDB ID index' }

      t.timestamps
    end
  end
end
