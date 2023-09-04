# frozen_string_literal: true

class PSNAccountsController < ApplicationController
  def index
    @account_data = PSNAccount.all.map { |account| helpers.get_account_data(account) }
  end

  def show
    @account = PSNAccount.find_by(id: params[:id])

    if @account.present?
      @trophy_lists = @account.account_trophy_lists.map do |account_list|
        helpers.get_trophy_list_data(account_list, account_list.earned_trophies)
      end
    else
      redirect_to(psn_accounts_path)
    end
  end
end
