require 'digest'
require 'openssl'

require 'sekrat/crypter/aes/version'
require 'sekrat/crypter/base'
require 'sekrat/errors'

module Sekrat
  module Crypter

    # A Sekrat::Crypter implementation 
    module Aes

      # Given a key and some data, encrypt the data via the AES-256-GCM
      # algorithm and return the resulting payload. The payload includes the
      # nonce used as well as the authentication data for the embedded
      # ciphertext.
      # @param key [String] the key to use for encryption
      # @param data [String] the data to encrypt
      # @return [String] the encrypted payload
      # @raise [Sekrat::EncryptFailure] if there are any problems along the way
      def self.encrypt(key, data)
        begin
          cipher.tap do |encryptor|
            key = Digest::SHA256.digest(key)
            iv = encryptor.random_iv

            encryptor.encrypt
            encryptor.key = key
            encryptor.iv = iv

            ciphertext = encryptor.update(data)
            ciphertext << encryptor.final

            auth_tag = encryptor.auth_tag

            return iv + ciphertext + auth_tag
          end
        rescue
          raise EncryptFailure.new("could not encrypt")
        end
      end

      # Given a key and some data, decrypt the data via the AES-256-GCM
      # algorithm and return the plain text.
      # @param key [String] the key to use for decryption
      # @param data [String] the encrypted payload to decrypt
      # @return [String] the decrypted data
      # @raise [Sekrat::DecryptFailure] if there are any problems along the way
      def self.decrypt(key, data)
        begin
          key = Digest::SHA256.digest(key)
          iv = data[0 .. 11]
          auth_tag = data[-16 .. -1]
          ciphertext = data[12 .. -17]

          cipher.tap do |decryptor|
            decryptor.decrypt
            decryptor.key = key
            decryptor.iv = iv
            decryptor.auth_tag = auth_tag

            plain = decryptor.update(ciphertext)
            plain << decryptor.final

            return plain
          end
        rescue
          raise DecryptFailure.new
        end
      end

      # @private
      def self.cipher
        OpenSSL::Cipher.new('aes-256-gcm')
      end

    end
  end
end
