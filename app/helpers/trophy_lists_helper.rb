# frozen_string_literal: true

module TrophyListsHelper
  def trophy_rank_icon(rank)
    image_tag("psn/#{rank}-trophy.png", width: 40, height: 40, alt: rank)
  end

  def hidden_icon
    '<i class="fa-regular fa-eye-slash"></i>'
  end
end
