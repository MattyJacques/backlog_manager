# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Release do
  subject(:release) { build(:release) }

  it { is_expected.to belong_to(:game) }
  it { is_expected.to belong_to(:platform) }
  it { is_expected.to belong_to(:trophy_list).optional(true).dependent(:destroy) }

  it do
    expect(release).to define_enum_for(:region).with_values(
      { europe: 1, north_america: 2, australia: 3, new_zealand: 4, japan: 5, china: 6, asia: 7, worldwide: 8, korea: 9,
        brazil: 10 }
    ).with_prefix
  end
end
