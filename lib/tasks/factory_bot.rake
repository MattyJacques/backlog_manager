# frozen_string_literal: true

namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    # see: https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md#linting-factories
    if Rails.env.test?
      ActiveRecord::Base.connection.transaction do
        FactoryBot.lint(strategy: :create, traits: true, verbose: true)
        raise ActiveRecord::Rollback
      end

      puts 'Successfully linted'
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      raise if $CHILD_STATUS.exitstatus.nonzero?
    end
  end
end
