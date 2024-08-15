# frozen_string_literal: true

module GamesHelper
  def sort_link(column:, label:)
    direction = column == params[:order] ? next_direction : 'asc'
    link_to(label, games_path(order: column, direction:), data: { turbo_action: 'replace' }, class: 'table-dark')
  end

  def show_sort_indicator(column)
    sort_indicator if params[:order] == column
  end

  private

  def next_direction
    params[:direction] == 'asc' ? 'desc' : 'asc'
  end

  def sort_indicator
    tag.span(class: "fas fa-solid fa-sort-#{params[:direction] == 'asc' ? 'up' : 'down'}")
  end
end
