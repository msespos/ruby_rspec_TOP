# frozen_string_literal: true

require_relative '../lib/16a_caesar_breaker'
require_relative '../lib/16b_caesar_translator'

# The file order to complete this lesson:

# 1. Familarize yourself with the four lib/16 files.
#    - lib/15_binary_main
#    - lib/16a_caesar_breaker
#    - lib/16b_caesar_translator which is based on the typical Caesar Cipher
#    - lib/16c_database (module)
# 2. Check out the completed tests in spec/16b_caesar_translator.
# 3. Complete spec/16a_caesar_breaker_spec.

# The CaesarBreaker class creates the 25 possible translations (using the
# CaesarTranslator class) and saves them in a yaml file (using a Database module).

# Let's write tests for the CaesarBreaker class & the included Database module.

# In this lesson, you will be writing tests for 2 methods -
# #create_decrypted_messages, and #save_to_yaml. In addition, you will learn
# about testing module methods and how to handle testing methods that can raise
# errors.

describe CaesarBreaker do
  # The tests for CaesarBreaker do not depend on creating different conditions.
  # Therefore we can use the same subject instance for most of these tests.

  # SHOULD WE CREATE NEW ONES FOR EACH TEST???

  subject(:phrase) { described_class.new('Ebiil, Tloia!') }

  describe '#decrypt' do
    # Public Script Method -> No test neccessary, but all methods inside should
    # be tested.
  end

  # ASSIGNMENT #1
  # Write the following test for #create_decrypted_messages

  describe '#create_decrypted_messages' do
    # Located inside #decrypt (Public Script Method)

    # Method with Outgoing Command -> Test that a message is sent
    let(:translator_create) { instance_double(CaesarTranslator) }
    subject(:phrase_create) { described_class.new('Lipps, Asvph!', translator_create) }

    it 'sends translate 26 times' do
      expect(translator_create).to receive(:translate).exactly(26).times
      phrase_create.create_decrypted_messages
    end
  end

  # MODULE TESTING: There are several ways to test methods inside a module.

  # Some prefer explicitly including it in the configuration option.
  # https://relishapp.com/rspec/rspec-core/docs/helper-methods/define-helper-methods-in-a-module

  # Some prefer testing modules using a dummy class.
  # https://mixandgo.com/learn/how-to-test-ruby-modules-with-rspec

  # Modules can also be tested in a class that includes it, which is how the
  # following tests work.

  # Incoming Command -> Assert the direct public side effects
  # You'll find the below method in 16_database.rb
  describe '#save_decrypted_messages' do
    # This method has a rescue block in case an error occurs.
    # Let's test that this method can run without raising an error.
    # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/raise-error-matcher

    context 'when it saves a file' do
      it 'does not raise an error' do
        expect { phrase.save_decrypted_messages }.not_to raise_error
      end

      # The test above will pass when you run it, but it will also output
      # two lines from #display_file_location.
      # So let's stub out that method to clean up the test output.
      it 'does not raise an error' do
        allow(phrase).to receive(:display_file_location)
        expect { phrase.save_decrypted_messages }.not_to raise_error
      end
    end

    # Let's simulate an error occuring during #save_decrypted_messages by
    # allowing File.open to raise the error 'Errno::ENOENT'. This error means
    # that no such file or directory could be found.
    context 'when rescuing an error' do
      before do
        allow(File).to receive(:open).and_raise(Errno::ENOENT)
        allow(phrase).to receive(:puts).twice
      end

      # When an error is rescued, the method will not raise an error. Therefore,
      # you test the conditions that would occur if an error were rescued.
      it 'rescues error' do
        expect { phrase.save_decrypted_messages }.not_to raise_error
      end

      it 'does not display file location' do
        expect(phrase).not_to receive(:display_file_location)
        phrase.save_decrypted_messages
      end

      it 'displays error rescue message' do
        expect(phrase).to receive(:puts).twice
        phrase.save_decrypted_messages
      end
    end
  end

  # ASSIGNMENT #3
  # Write the following test for #save_to_yaml
  # This method is found in 16_database.rb

  # Outgoing Command -> Expect to send
  describe '#save_to_yaml' do
    it 'dumps to yaml' do
      expect(YAML).to receive(:dump)
      phrase.save_to_yaml
    end
  end
end
