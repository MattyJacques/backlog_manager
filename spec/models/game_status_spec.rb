# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameStatus do
  subject(:status) { build(:game_status) }

  it do
    expect(described_class.new).to define_enum_for(:status)
      .with_values(%i[wishlist backlog ready_to_play playing beaten completed shelved abandoned])
      .backed_by_column_of_type(:integer)
  end

  it { is_expected.to belong_to(:game) }
end
