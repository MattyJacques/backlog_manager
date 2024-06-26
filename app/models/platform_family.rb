# frozen_string_literal: true

class PlatformFamily < ApplicationRecord
  has_many :platforms, dependent: :nullify, autosave: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
