class TwoFactorOptionsForm
  include ActiveModel::Model

  attr_accessor :otp_delivery_preference

  validates :otp_delivery_preference, inclusion: { in: %w[voice sms auth_app piv_cac] }

  def initialize(user)
    self.user = user
  end

  def submit(params)
    self.otp_delivery_preference = params[:otp_delivery_preference]

    success = valid?

    update_otp_delivery_preference_for_user if otp_delivery_preference_changed? && success

    FormResponse.new(success: success, errors: errors.messages, extra: extra_analytics_attributes)
  end

  private

  attr_accessor :user

  def extra_analytics_attributes
    {
      otp_delivery_preference: otp_delivery_preference,
    }
  end

  def otp_delivery_preference_changed?
    otp_delivery_preference != user.otp_delivery_preference
  end

  def update_otp_delivery_preference_for_user
    user_attributes = { otp_delivery_preference: otp_delivery_preference }
    UpdateUser.new(user: user, attributes: user_attributes).call
  end
end
