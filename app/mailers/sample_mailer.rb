class SampleMailer < ApplicationMailer
  def sample_notice(mail_address)
    @greet = 'Hello World'
    @areas = Area.all
    mail(to: mail_address, subject: 'sample mailerの件名')
  end
end
