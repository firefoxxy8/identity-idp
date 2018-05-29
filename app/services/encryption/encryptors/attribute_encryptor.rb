module Encryption
  module Encryptors
    class AttributeEncryptor
      include Pii::Encodable

      def initialize
        @aes_cipher = Pii::Cipher.new
      end

      def encrypt(plaintext)
        aes_encrypted_ciphertext = aes_cipher.encrypt(plaintext, aes_encryption_key)
        encode(aes_encrypted_ciphertext)
      end

      def decrypt(ciphertext)
        return DeprecatedAttributeEncryptor.new.decrypt(ciphertext) if legacy?(ciphertext)
        raise Pii::EncryptionError, 'ciphertext invalid' unless valid_base64_encoding?(ciphertext)
        decoded_ciphertext = decode(ciphertext)
        aes_cipher.decrypt(decoded_ciphertext, aes_encryption_key)
      end

      def stale?
        false
      end

      private

      attr_reader :aes_cipher

      def legacy?(ciphertext)
        Encryption::KmsClient.looks_like_kms?(ciphertext) || ciphertext.to_s.index('.')
      end

      def aes_encryption_key
        Figaro.env.attribute_encryption_key
      end
    end
  end
end
