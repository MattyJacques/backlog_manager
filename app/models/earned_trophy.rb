# frozen_string_literal: true

class EarnedTrophy < ApplicationRecord
  belongs_to :psn_account
  belongs_to :trophy
end
