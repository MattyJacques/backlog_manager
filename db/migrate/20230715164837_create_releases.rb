class CreateReleases < ActiveRecord::Migration[7.0]
  def change
    create_table :releases do |t|
      t.belongs_to :game, null: false, foreign_key: true
      t.belongs_to :platform, null: false, foreign_key: true
      t.integer :region
      t.date :date
      t.belongs_to :trophy_list, foreign_key: true

      t.timestamps
    end
  end
end
