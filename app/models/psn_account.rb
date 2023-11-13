# frozen_string_literal: true

class PSNAccount < ApplicationRecord
  belongs_to :user, optional: true
  has_many :account_trophy_lists, dependent: :destroy
  has_many :trophy_lists, through: :account_trophy_lists
  has_many :earned_trophies, through: :account_trophy_lists
  has_many :trophies, through: :earned_trophies

  validates :psn_id, presence: true, uniqueness: { case_sensitive: false }

  after_commit :update_trophies, if: proc { |object| object.previous_changes.include?('psn_id') }

  def earned_trophy_count
    earned_bronze + earned_silver + earned_gold + earned_platinum
  end

  private

  def update_trophies
    PSN::UpdatePSNAccountJob.perform_later(id, should_scrape: true)
  end
end
