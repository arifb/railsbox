RSpec.describe Box do
  it { is_expected.to     validate_presence_of(:params) }
  it { is_expected.not_to allow_value('<test').for(:vm_name) }
  it { is_expected.to     allow_value('my_app').for(:vm_name) }
  it { is_expected.to     allow_value('my-app').for(:vm_name) }

  describe 'secure_id' do
    let(:params) { { params: {databases: []} } }

    before { allow(SecureIdGenerator).to receive(:generate) { '123' } }

    it 'generates unique secure id' do
      box = described_class.create!(params)
      expect(box.secure_id).to eql '123'
    end

    it 'checks the uniqueness of secure id' do
      described_class.create!(params)
      expect(described_class.new(params)).not_to be_valid
    end
  end

  describe '#to_param' do
    it 'returns secure_id' do
      box = Box.new secure_id: 'abc123'
      expect(box.to_param).to eq 'abc123'
    end
  end

  describe '#vm_name' do
    it 'will extract name from params' do
      box = Box.new params: { vm_name: 'myapp' }
      expect(box.vm_name).to eq 'myapp'
    end
  end

  describe '.background_jobs' do
    subject { described_class.background_jobs.map(&:id) }

    it { is_expected.to include 'sidekiq' }
  end
end
