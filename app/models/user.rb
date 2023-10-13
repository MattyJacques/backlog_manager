# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are: :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, authentication_keys: [:username]

  has_one :psn_account, dependent: :destroy
  has_many :game_statuses, dependent: :destroy

  accepts_nested_attributes_for :psn_account,
                                reject_if: ->(attributes) { attributes['psn_id'].blank? },
                                allow_destroy: true

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
