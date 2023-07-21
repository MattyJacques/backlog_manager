# frozen_string_literal: true

class TrophyList < ApplicationRecord
  enum region: { europe: 0, north_america: 1, germany: 2, asia: 3, china: 4, japan: 5, original: 6 }

  has_many :releases, dependent: :nullify
  has_many :trophies, dependent: :destroy
  has_many :account_trophy_lists, dependent: :destroy
  has_many :psn_accounts, through: :account_trophy_lists

  validates :communication_id, presence: true,
                               format: { with: /\ANPWR[0-9]{5}_00\z/ },
                               uniqueness: { case_sensitive: false }
  validates :title_id, uniqueness: { case_sensitive: false, allow_nil: true }
  validates :service, presence: true
end
