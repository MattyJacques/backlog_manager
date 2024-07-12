# frozen_string_literal: true

class Platform < ApplicationRecord
  belongs_to :platform_family, optional: true

  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :slug, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true

  after_create :import_igdb_data

  private

  def import_igdb_data
    IGDB::ImportPlatformJob.perform_later(igdb_id)
  end
end
