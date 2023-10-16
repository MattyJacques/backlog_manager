# frozen_string_literal: true

class PSNAccount < ApplicationRecord
  has_many :account_trophy_lists, dependent: :destroy
  has_many :trophy_lists, through: :account_trophy_lists
  has_many :earned_trophies, through: :account_trophy_lists
  has_many :trophies, through: :earned_trophies

  validates :psn_id, presence: true, uniqueness: { case_sensitive: false }

  after_commit :update_trophies, if: proc { |object| object.previous_changes.include?('psn_id') }

  private

  def update_trophies
    PSN::UpdatePSNAccountJob.perform_later(id, should_scrape: true)
  end
end
