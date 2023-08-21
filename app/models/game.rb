# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :releases, dependent: :destroy
  has_many :platforms, through: :releases
  has_many :trophy_lists, through: :releases
  has_many :game_statuses, dependent: :destroy

  FILTER_PARAMS = %i[name platform_id sort_by direction].freeze

  validates :name, presence: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
  validates :how_long_to_beat_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true

  scope :by_name, ->(query) { where('games.name like ?', "%#{query}%") }
  scope :by_platform, ->(platform_id) { where(releases: { platform_id: }) }

  def self.filter(filters)
    games = Game.includes(:releases, :platforms, :trophy_lists).by_name(filters['name'])
    games = games.by_platform(filters['platform_id']) if filters['platform_id'].present?

    sort_list(games, filters['sort_by'], filters['direction'])
  end

  def self.sort_list(games, sort_by, direction)
    return games if sort_by.blank?

    case sort_by
    when 'name'
      sort_by_name(games, direction)
    when 'platform'
      sort_by_platform(games, direction)
    end
  end

  def self.sort_by_name(games, direction)
    games.order(Arel.sql("lower(name) #{direction == 'asc' ? 'asc' : 'desc'}"))
  end

  def self.sort_by_platform(games, direction)
    games = games.sort_by { |game| game.platforms.map(&:abbreviation).flatten.join(', ') }
    handle_direction(games, direction)
  end

  def self.handle_direction(games, sort_direction)
    sort_direction == 'asc' ? games : games.reverse!
  end

  def status_for_user(user_id)
    game_statuses.find_by(user_id:)
  end
end
