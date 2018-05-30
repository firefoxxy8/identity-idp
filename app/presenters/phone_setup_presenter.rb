class PhoneSetupPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::TranslationHelper

  attr_reader :otp_delivery_preference

  def initialize(form)
    @user_phone_form = form
  end

  def heading
    if otp_delivery_preference == :voice
      t('titles.phone_setup.voice')
    else
      t('titles.phone_setup.sms')
    end
  end
  def image
    if otp_delivery_preference == :voice
      '2FA-phone-call.svg'
    else
      '2FA-text-message.svg'
    end
  end
  def label
    if otp_delivery_preference == :voice
      t('devise.two_factor_authentication.phone_voice_label')
    else
      t('devise.two_factor_authentication.phone_sms_label')
    end
  end
  def info
    if otp_delivery_preference == :voice
      t('devise.two_factor_authentication.phone_voice_info_html')
    else
      t('devise.two_factor_authentication.phone_sms_info_html')
    end
  end
end
