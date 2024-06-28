# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre do
  it { is_expected.to have_and_belong_to_many(:games) }
end
