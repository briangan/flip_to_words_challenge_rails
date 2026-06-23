require 'test_helper'

module FlipToWords
  class ParameterEncryptorTest < ActiveSupport::TestCase
    setup do
      # Mock the FlipLetter constants for tests
      unless defined?(FlipToWords::FlipLetter::ROWS_FOR_LETTER)
        FlipToWords::FlipLetter.const_set(:ROWS_FOR_LETTER, 5) unless FlipToWords::FlipLetter.const_defined?(:ROWS_FOR_LETTER)
        FlipToWords::FlipLetter.const_set(:COLUMNS_FOR_LETTER, 3) unless FlipToWords::FlipLetter.const_defined?(:COLUMNS_FOR_LETTER)
      end
    end

    test "encrypts parameter names consistently" do
      param1 = "P[0]"
      encrypted1 = ParameterEncryptor.encrypt(param1)
      encrypted2 = ParameterEncryptor.encrypt(param1)
      
      assert_equal encrypted1, encrypted2, "Same parameter should encrypt to same value"
      assert_not_equal param1, encrypted1, "Encrypted value should be different from original"
      
    end

    test "different parameters encrypt to different values and preserve suffix symbols" do
      param1 = "Q"
      param2 = "P[1]"
      
      encrypted1 = ParameterEncryptor.encrypt(param1)
      encrypted2 = ParameterEncryptor.encrypt(param2)
      
      assert_not_equal encrypted1, encrypted2, "Different parameters should encrypt differently"
    end

    test "encrypt and decrypt parameter names correctly" do
      param = "P[0]"
      encrypted = ParameterEncryptor.encrypt(param)
      decrypted = ParameterEncryptor.decrypt(encrypted)
      
      assert_equal param, decrypted, "Should decrypt to original parameter name"
    end

    test "encrypt and decrypt nested parameters correctly" do
      original = {
        "letters[]" => ["P", "Q"],
        "P[0]" => "1",
        "P[1]" => "0",
        "other_hash" => {
          "nested_param" => "value",
          "nested_array[]" => ["A", "B", "C"]
        }
      }
      encrypted = ParameterEncryptor.encrypt_params(original)
      assert encrypted.is_a?(Hash), "Encrypted result should be a hash"
      encrypted.each do |key, value|
        assert key.start_with?(ParameterEncryptor::ENCRYPTED_KEY_PREFIX), "Encrypted keys should start with prefix"
      end
      
      # Check suffix preserved in encrypted keys
      { '[]' => 1, '[0]' => 1, '[1]' => 1 }.each do|suffix, count|
        assert_equal count, encrypted.keys.find_all {|k| k.end_with?(suffix) }.size, "Should find correct number of keys with suffix #{suffix} in #{encrypted.keys.inspect}"
      end
      
      decrypted = ParameterEncryptor.decrypt_params(encrypted)
      assert decrypted.is_a?(Hash), "Decrypted result should be a hash"
      
      assert_equal original, decrypted, "Should decrypt to original parameter name"

      # Add non-encrypted parameter to test mixed case
      mixed_params = encrypted.merge("some_other_param" => "value")
      decrypted_mixed = ParameterEncryptor.decrypt_params(mixed_params)
      
      assert_equal "value", decrypted_mixed["some_other_param"], "Non-encrypted parameter should remain unchanged"
      decrypted_mixed.delete("some_other_param")
      assert_equal original, decrypted_mixed, "Should decrypt to original parameter name after removing non-encrypted parameter"
    end

    test "encrypt_param_for_view returns encrypted parameter" do
      param = "A[0]"
      encrypted = ParameterEncryptor.encrypt_param_for_view(param)
      assert encrypted.end_with?("[0]"), "Encrypted value should preserve suffix symbols"
      
      assert encrypted.start_with?( ParameterEncryptor::ENCRYPTED_KEY_PREFIX), "Encrypted parameter should start with prefix"
      assert_not_equal param, encrypted
    end
  end
end
