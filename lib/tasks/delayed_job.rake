# frozen_string_literal: true

require 'English'

namespace :delayed_job do
  desc 'Start the delayed job worker'
  task start: :environment do
    Rails.logger.extend(
      ActiveSupport::Logger.broadcast(ActiveSupport::Logger.new($stdout))
    )

    Rake::Task['jobs:work'].invoke
  end
end
