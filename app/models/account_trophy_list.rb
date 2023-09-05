# frozen_string_literal: true

class AccountTrophyList < ApplicationRecord
  belongs_to :psn_account
  belongs_to :trophy_list
  has_many :earned_trophies, dependent: :destroy
end
