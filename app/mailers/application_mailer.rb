class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('sfhelpdesk@sofolha.com.br', 'SFHelpdesk')
  default reply_to: email_address_with_name('sfhelpdesk@sofolha.com.br', 'SFHelpdesk')  
  layout 'mailer'
end
