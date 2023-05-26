# frozen_string_literal: true

# Generic application mailers
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
