class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres do |t|
      t.string :name
      t.string :slug
      t.integer :igdb_id, null: false

      t.timestamps
    end
  end
end
