##
# Service for encrypting and decrypting parameter names in the Flip to Words Challenge.
# This prevents bots from easily understanding the parameter structure.
#
# Uses a keyed hash (HMAC-SHA256) combined with Base64 encoding for consistent,
# reversible encryption of parameter names.
module FlipToWords
  class ParameterEncryptor

    ENCRYPTED_KEY_PREFIX = "fp_".freeze
    
    # So far only brackets are considered as suffix symbols.
    SYMBOL_SUFFIX = /(\[.*?\])\Z/.freeze 
    
    ##
    # Plainly encrypts a parameter name using AES-128-GCM encryption and Base64 encoding.
    # This does not include any prefix or suffix.
    # @param param_name <String> The parameter name to encrypt (e.g., "pname", "P[0]", "letters[]")
    # @return <String> The encrypted parameter name
    def self.encrypt(param_name)
      cipher = OpenSSL::Cipher.new('aes-128-gcm')
      cipher.encrypt
      cipher.key = secret_key[0, 16] # AES-128 requires 16-byte key
      
      # Generate a deterministic IV from the parameter name
      # This ensures same input always produces same output
      iv = OpenSSL::HMAC.digest('SHA256', secret_key, param_name)[0, 12]
      cipher.iv = iv
      
      # Encrypt the parameter name
      encrypted = cipher.update(param_name) + cipher.final
      auth_tag = cipher.auth_tag
      
      # Combine IV + auth_tag + encrypted data and encode as URL-safe base64
      combined = iv + auth_tag + encrypted
      Base64.urlsafe_encode64(combined, padding: false)
    end

    ##
    # Encryption of key names in a @params with prefix @key_prefix.  Can handle nested hash/parameters.
    # Parameter names for set of values w/ suffix symbols (e.g., "letters[]" or "letters[1]") would have name encrypted 
    # but symbol segment preserved.
    # @params <Hash> The parameters hash to encrypt (e.g., {"P[0]" => "1", "letters[]" => ["P", "Q"]})
    # @key_prefix [String] The prefix to use for the encrypted hash key/name (default: ENCRYPTED_KEY_PREFIX)
    def self.encrypt_params(params, key_prefix = ENCRYPTED_KEY_PREFIX)
      encrypted = {}
      params.each do |key, value| 
        no_suffix = key.sub(SYMBOL_SUFFIX, '') # Extract brackets (e.g., "[]" or "[0]")
        symbol_suffix = $1.to_s
        encrypted_key = encrypt(no_suffix)
        
        # Handle nested parameters (e.g., "P[0]" becomes nested hash)
        if value.is_a?(Hash)
          encrypted[key_prefix + encrypted_key + symbol_suffix] = encrypt_params(value, key_prefix)
        else
          encrypted[key_prefix + encrypted_key + symbol_suffix] = value
        end
      end
      encrypted
    end

    ##
    # Plainly decrypts a parameter name back to its original form.  This does not consider any prefix.
    # @param encrypted_value [String] The encrypted parameter name
    # @return <String> The original parameter name if found, nil otherwise
    def self.decrypt(encrypted_value)
      begin
        # Decode from base64
        combined = Base64.urlsafe_decode64(encrypted_value)
        
        # Extract IV (first 12 bytes), auth_tag (next 16 bytes), and encrypted data
        iv = combined[0, 12]
        auth_tag = combined[12, 16]
        encrypted = combined[28..-1]
        
        # Decrypt
        decipher = OpenSSL::Cipher.new('aes-128-gcm')
        decipher.decrypt
        decipher.key = secret_key[0, 16]
        decipher.iv = iv
        decipher.auth_tag = auth_tag
        
        decipher.update(encrypted) + decipher.final
      rescue => e
        Rails.logger.error "Failed to decrypt parameter: #{e.message}"
        nil
      end
    end    
    
    ##
    # Decrypts all parameters with keys starting with @key_prefix, replacing them with original keys
    # @params <Hash> The parameters hash with encrypted keys (e.g., {"fp_abc123" => "1", "fp_xyz789[]" => ["P", "Q"]})
    # @key_prefix [String] The prefix to use for the encrypted hash key/name (default: ENCRYPTED_KEY_PREFIX)
    # @return [Hash] The parameters hash with decrypted keys
    def self.decrypt_params(params, key_prefix = ENCRYPTED_KEY_PREFIX)
      decrypted = {}
      
      params.each do |key, value|
        encrypted_part = key.sub(/^(#{Regexp.escape(key_prefix)})/, '')
        prefix = $1
        if prefix
          no_suffix = encrypted_part.sub(SYMBOL_SUFFIX, '') # Extract brackets (e.g., "[]" or "[0]")
          symbol_suffix = $1.to_s
          original_key = decrypt(no_suffix)
          decrypted[original_key + symbol_suffix] = value.is_a?(Hash) ? decrypt_params(value, key_prefix) : value
        else
          decrypted[key] = value.is_a?(Hash) ? decrypt_params(value, key_prefix) : value
        end
      end
      
      decrypted
    end

    ##
    # Helper method to encrypt parameter names in view helpers
    # Converts "P[0]" to "fp_xxxxx" format
    # @param param_name [String] The parameter name to encrypt
    # @return [String] The encrypted parameter name
    def self.encrypt_param_for_view(param_name)
      no_suffix = param_name.sub(SYMBOL_SUFFIX, '')
      symbol_suffix = $1.to_s
      ENCRYPTED_KEY_PREFIX + encrypt(no_suffix) + symbol_suffix
    end

    private

    # The secret key used for encryption. In production, this should be stored in Rails credentials.
    # For development/test, we use a default key.
    def self.secret_key
      @secret_key ||= begin
        if Rails.application.credentials.flip_to_words_secret_key.present?
          Rails.application.credentials.flip_to_words_secret_key
        elsif ENV['FLIP_TO_WORDS_SECRET_KEY'].present?
          ENV['FLIP_TO_WORDS_SECRET_KEY']
        else
          # Default key for development/test - should be changed in production
          Rails.application.secret_key_base.byteslice(0, 32)
        end
      end
    end
  end
end
