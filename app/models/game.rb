# frozen_string_literal: true

class Game < ApplicationRecord
  FILTER_PARAMS = %i[name platform_id sort_by direction].freeze

  has_many :releases, dependent: :destroy
  has_many :platforms, through: :releases
  has_many :trophy_lists, through: :releases
  has_many :game_statuses, dependent: :destroy

  validates :name, presence: true
  validates :igdb_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true
  validates :how_long_to_beat_id, numericality: { only_integer: true }, uniqueness: true, allow_nil: true

  scope :by_name, ->(query) { where('games.name like ?', "%#{query}%") }
  scope :by_platform, ->(platform_id) { where(releases: { platform_id: }) }

  class << self
    def filter(filters)
      games = Game.includes(:releases, :trophy_lists, :platforms).by_name(filters['name'])
      games = games.by_platform(filters['platform_id']) if filters['platform_id'].present?

      sort_list(games, filters['sort_by'], filters['direction'])
    end

    private

    def sort_list(games, sort_by, direction)
      return games if sort_by.blank?

      case sort_by
      when 'name'
        sort_by_name(games, direction)
      when 'platform'
        sort_by_platform(games, direction)
      end
    end

    def sort_by_name(games, direction)
      games.order(Arel.sql("lower(games.name) #{direction == 'asc' ? 'asc' : 'desc'}"))
    end

    def sort_by_platform(games, direction)
      games = games.sort_by { |game| game.platforms.map(&:abbreviation).flatten.join(', ') }
      handle_direction(games, direction)
    end

    def handle_direction(games, sort_direction)
      sort_direction == 'asc' ? games : games.reverse!
    end
  end
  # class << self

  def status_for_user(user_id)
    game_statuses.find(user_id:)
  end
end
