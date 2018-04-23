module Users
  class TwoFactorAuthenticationSetupController < ApplicationController
    include UserAuthenticator
    include PhoneConfirmation

    before_action :authorize_otp_setup
    before_action :authenticate_user

    def index
      @two_factor_options_form = TwoFactorOptionsForm.new(current_user)
      analytics.track_event(Analytics::USER_REGISTRATION_PHONE_SETUP_VISIT)
    end

    def create
      @two_factor_options_form = TwoFactorOptionsForm.new(current_user)
      result = @two_factor_options_form.submit(params[:two_factor_options_form])
      # analytics.track_event(Analytics::USER_REGISTRATION_PHONE_SETUP_VISIT)

      if result.success?
        process_valid_form
      else
        render :index
      end
    end

    private

    def authorize_otp_setup
      if user_fully_authenticated?
        redirect_to(request.referer || root_url)
      elsif current_user&.two_factor_enabled?
        redirect_to user_two_factor_authentication_url
      end
    end

    def process_valid_form
      case @two_factor_options_form.otp_delivery_preference
      when 'sms', 'voice'
        redirect_to phone_setup_url
      when 'auth_app'
        redirect_to authenticator_setup_url
      end
    end
  end
end
