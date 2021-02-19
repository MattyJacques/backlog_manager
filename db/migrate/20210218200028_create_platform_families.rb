class CreatePlatformFamilies < ActiveRecord::Migration[6.1]
  def change
    create_table :platform_families do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
