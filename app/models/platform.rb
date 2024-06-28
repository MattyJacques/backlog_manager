# frozen_string_literal: true

class Platform < ApplicationRecord
  belongs_to :platform_family, optional: true

  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :slug, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
