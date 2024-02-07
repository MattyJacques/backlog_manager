# frozen_string_literal: true

class Platform < ApplicationRecord
  belongs_to :platform_family, optional: true
  has_many :releases, dependent: :destroy
  has_many :games, through: :releases

  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
  validates :slug, uniqueness: { case_sensitive: false }, allow_nil: true

  after_create :import_igdb_platform

  private

  def import_igdb_platform
    return if name.present?

    IGDB::ImportPlatformJob.perform_later(igdb_id)
  end
end
