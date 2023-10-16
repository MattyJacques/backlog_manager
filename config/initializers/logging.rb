# frozen_string_literal: true

# Make delayed job output go to terminal as well as file
Rails.logger.extend(
  ActiveSupport::Logger.broadcast(
    ActiveSupport::Logger.new($stdout)
  )
)
