require 'rails_helper'

describe Users::TwoFactorAuthenticationSetupController do
  describe 'GET index' do
    it 'tracks the visit in analytics' do
      sign_in(create(:user))
      stub_analytics

      expect(@analytics).to receive(:track_event).
        with(Analytics::USER_REGISTRATION_OTP_PREFERENCE_VISIT)

      get :index
    end

    context 'when signed out' do
      it 'redirects to sign in page' do
        get :index

        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH create' do
    it 'updates otp delivery preference for user' do
      user = create(:user)
      sign_in(user)

      patch :create, params: {
        two_factor_options_form: {
          otp_delivery_preference: 'voice',
        },
      }
      user.reload

      expect(user.otp_delivery_preference).to eq('voice')
    end

    it 'tracks analytics event' do
      sign_in(create(:user))
      stub_analytics

      result = {
        otp_delivery_preference: 'voice',
        success: true, 
        errors: {},
      }

      expect(@analytics).to receive(:track_event).
        with(Analytics::MULTI_FACTOR_AUTH_OTP_PREFERENCE_SELECTED, result)

      patch :create, params: {
        two_factor_options_form: {
          otp_delivery_preference: 'voice',
        },
      }
    end
  end
end
