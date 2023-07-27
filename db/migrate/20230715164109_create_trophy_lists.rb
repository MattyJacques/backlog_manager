class CreateTrophyLists < ActiveRecord::Migration[7.0]
  def change
    create_table :trophy_lists do |t|
      t.string :name
      t.string :detail
      t.string :comm_id, null: false, index: { unique: true, name: 'unique PSN communication ID index' }
      t.string :title_id, index: { unique: true, name: 'unique PSN title ID index' }
      t.string :service, null: false
      t.integer :region
      t.decimal :version
      t.string :icon_url, null: false
      t.date :server_shutdown_date
      t.string :psnp_id
      t.string :psntl_id

      t.timestamps
    end
  end
end
