# frozen_string_literal: true

class EarnedTrophy < ApplicationRecord
  belongs_to :account_trophy_list
  belongs_to :trophy
  has_one :psn_account, through: :account_trophy_list
  has_one :trophy_list, through: :account_trophy_list
end
