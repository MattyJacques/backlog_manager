# frozen_string_literal: true

class TrophyListsController < ApplicationController
  def index
    @lists = TrophyList.all.order(:comm_id) { |l| l.comm_id.delete('^0-9').to_i }
  end

  def show
    @list = TrophyList.find_by(id: params[:id])

    redirect_to(trophy_lists_path) if @list.nil?
  end
end
