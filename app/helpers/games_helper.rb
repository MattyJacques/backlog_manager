# frozen_string_literal: true

module GamesHelper
  def sort_link(column:, label:)
    direction = column == session.dig('filters', 'order') ? next_direction : 'asc'
    link_to(label, games_path(order: column, direction:), data: { turbo_action: 'replace' }, class: 'table-dark')
  end

  def show_sort_indicator(column)
    sort_indicator if session.dig('filters', 'order') == column
  end

  def cover_url(image_id)
    return "https://images.igdb.com/igdb/image/upload/t_cover_big/#{image_id}.webp" if image_id.present?
  end

  private

  def next_direction
    session.dig('filters', 'direction') == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator
    tag.span(class: "fas fa-solid fa-sort-#{session.dig('filters', 'direction') == 'asc' ? 'up' : 'down'}")
  end
end
