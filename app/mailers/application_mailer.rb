class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: Rails.configuration.action_mailer.smtp_settings[:user_name]
end
