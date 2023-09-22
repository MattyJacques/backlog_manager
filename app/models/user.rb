# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are: :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, authentication_keys: [:username]

  has_many :game_statuses, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
