# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameStatus do
  it do
    expect(described_class.new).to define_enum_for(:status).with_values(
      { wishlist: 1, backlog: 2, ready_to_play: 3, playing: 4,
        beaten: 5, completed: 6, shelved: 7, abandoned: 8 }
    )
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:game) }
end
