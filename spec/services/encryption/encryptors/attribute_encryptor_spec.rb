require 'rails_helper'

describe Encryption::Encryptors::AttributeEncryptor do
  let(:plaintext) { 'some secret text' }
  let(:current_key) { '1' * 32 }

  before do
    allow(Figaro.env).to receive(:attribute_encryption_key).and_return(current_key)
  end

  describe '#encrypt' do
    it 'returns encrypted text' do
      ciphertext = subject.encrypt(plaintext)

      expect(ciphertext).to_not eq(plaintext)
    end

  end

  describe '#decrypt' do
    let(:ciphertext) do
      subject.encrypt(plaintext)
    end

    context 'with a ciphertext made with the current key' do
      it 'decrypts the ciphertext' do
        expect(subject.decrypt(ciphertext)).to eq(plaintext)
      end
    end
  end

  describe '#stale?' do
    it 'returns false for backward compatability' do
      expect(subject.stale?).to eq(false)
    end
  end
end
