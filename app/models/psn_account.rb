# frozen_string_literal: true

class PSNAccount < ApplicationRecord
  validates :psn_id, presence: true, uniqueness: { case_sensitive: false }
end
