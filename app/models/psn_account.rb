# frozen_string_literal: true

class PSNAccount < ApplicationRecord
  has_many :account_trophy_lists, dependent: :destroy
  has_many :trophy_lists, through: :account_trophy_lists

  validates :psn_id, presence: true, uniqueness: { case_sensitive: false }
end
