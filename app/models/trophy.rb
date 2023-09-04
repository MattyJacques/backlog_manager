# frozen_string_literal: true

class Trophy < ApplicationRecord
  enum :rank, { bronze: 0, silver: 1, gold: 2, platinum: 3 }

  belongs_to :trophy_list
  has_many :earned_trophies, dependent: :destroy
  has_many :account_trophy_lists, through: :earned_trophies
  has_many :psn_accounts, through: :account_trophy_lists

  validates :psn_id, presence: true, uniqueness: { scope: :trophy_list_id }
  validates :name, presence: true
  validates :detail, presence: true
  validates :icon_url, presence: true
  validates :rank, presence: true
end
