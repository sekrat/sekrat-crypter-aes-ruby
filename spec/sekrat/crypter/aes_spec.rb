require 'securerandom'

RSpec.describe Sekrat::Crypter::Aes do
  it "has a version number" do
    expect(Sekrat::Crypter::Aes::VERSION).not_to be nil
  end

  describe '.encrypt' do
    let(:key) {SecureRandom.hex(5)}
    let(:data) {SecureRandom.hex(32)}
    let(:encrypt) {described_class.encrypt(key, data)}

    context 'when all goes well' do
      it 'is a string' do
        expect(encrypt).to be_a(String)
      end

      it 'is reversiable with the same key' do
        expect(described_class.decrypt(key, encrypt)).to eql(data)
      end
    end

    context 'when problems occur' do
      before(:each) do
        allow_any_instance_of(OpenSSL::Cipher).
          to receive(:final).
          and_raise(StandardError)
      end

      it 'raises an error' do
        expect {encrypt}.to raise_error(Sekrat::EncryptFailure)
      end
    end
  end

  describe '.decrypt' do
    let(:key) {SecureRandom.hex(5)}
    let(:data) {SecureRandom.hex(32)}
    let!(:encrypted) {described_class.encrypt(key, data)}
    let(:decrypt) {described_class.decrypt(key, encrypted)}

    context 'when all goes well' do
      it 'is the original data' do
        expect(decrypt).to eql(data)
      end
    end

    context 'when problems occur' do
      before(:each) do
        allow_any_instance_of(OpenSSL::Cipher).
          to receive(:final).
          and_raise(StandardError)
      end

      it 'raises an error' do
        expect {decrypt}.to raise_error(Sekrat::DecryptFailure)
      end
    end
  end

end
