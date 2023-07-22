# frozen_string_literal: true

module PSNAccountsHelper
  def get_account_data(account)
    {
      id: account.id,
      psn_id: account.psn_id,
      game_count: account.account_trophy_lists.count,
      platforms: account.account_trophy_lists.preload(trophy_list: :platforms).map do |list|
        list.trophy_list.platforms.map(&:abbreviation)
      end.flatten.uniq.join(', ')
    }.merge(trophy_counts(account.earned_trophies))
  end

  def get_trophy_list_data(account_list, earned_trophies)
    trophy_list = account_list.trophy_list

    {
      id: trophy_list.id,
      name: trophy_list.name,
      detail: trophy_list.detail,
      comm_id: trophy_list.comm_id,
      progress: "#{earned_trophies.count}/#{trophy_list.trophies.count}"
    }.merge(trophy_counts(earned_trophies))
  end

  private

  def trophy_counts(earned_trophies)
    trophies = earned_trophies.preload(:trophy)
    {
      trophy_count: trophies.count,
      bronze_count: trophies.select { |t| t.trophy.bronze? }.count,
      silver_count: trophies.select { |t| t.trophy.silver? }.count,
      gold_count: trophies.select { |t| t.trophy.gold? }.count,
      platinum_count: trophies.select { |t| t.trophy.platinum? }.count
    }
  end
end
