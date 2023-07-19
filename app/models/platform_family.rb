# frozen_string_literal: true

class PlatformFamily < ApplicationRecord
  has_many :platforms, dependent: :nullify

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
end
