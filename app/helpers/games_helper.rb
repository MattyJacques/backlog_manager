# frozen_string_literal: true

module GamesHelper
  def build_order_link(label:, sort_by:)
    if sort_by == session.dig('game_filters', 'sort_by')
      link_to(label, search_games_path(sort_by:, direction: next_direction), class: 'table-dark')
    else
      link_to(label, search_games_path(sort_by:, direction: 'asc'), class: 'table-dark')
    end
  end

  def sort_indicator
    tag.span(class: "fa-solid fa-sort-#{session.dig('game_filters', 'direction') == 'asc' ? 'up' : 'down'}")
  end

  private

  def next_direction
    params[:direction] == 'asc' ? 'desc' : 'asc'
  end
end
