class CreatePlatforms < ActiveRecord::Migration[6.1]
  def change
    create_table :platforms do |t|
      t.string :name, null: false
      t.date :release_date
      t.belongs_to :platform_family, foreign_key: true
      t.timestamps
    end
  end
end
