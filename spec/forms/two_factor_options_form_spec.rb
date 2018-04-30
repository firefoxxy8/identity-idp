require 'rails_helper'

describe TwoFactorOptionsForm do
  include Shoulda::Matchers::ActiveModel

  let(:user) { create(:user) }
  subject { described_class.new(user) }

  it { should validate_inclusion_of(:otp_delivery_preference).
    in_array(%w[voice sms auth_app]) }

  describe '#submit' do
    it 'is successful if the delivery preference is valid' do
      result = subject.submit(otp_delivery_preference: 'sms')

      expect(result.success?).to eq true
    end

    it 'is unsuccessful if the delivery preference is invalid' do
      result = subject.submit(otp_delivery_preference: '!!!!')

      expect(result.success?).to eq false
      expect(result.errors).to include :otp_delivery_preference
    end

    it 'updates the delivery prerfence on the user' do
      subject.submit(otp_delivery_preference: 'auth_app')
      user.reload

      expect(user.otp_delivery_preference).to eq 'auth_app'
    end
  end
end
