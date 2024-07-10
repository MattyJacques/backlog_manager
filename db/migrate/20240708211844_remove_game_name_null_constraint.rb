# frozen_string_literal: true

class RemoveGameNameNullConstraint < ActiveRecord::Migration[7.1]
  def up
    change_column_null :games, :name, true
  end

  def down
    Game.where(name: nil).update_all(name: 'MISSING NAME') # rubocop:disable Rails/SkipsModelValidations
    change_column_null :games, :name, false
  end
end
