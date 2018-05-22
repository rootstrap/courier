RSpec.describe Courier::Middleware do
  describe '#call' do
    let(:application) { double('Application') }
    let(:environment) { double('Environment') }
    let(:status) { double('status') }
    let(:headers) { double('headers') }
    let(:response) { double('response') }

    before :each do
      expect(application)
        .to receive(:call)
        .with(environment)
        .and_return([status, headers, response])
    end

    it 'implements call method' do
      expect { Courier::Middleware.new(application).call(environment) }
        .not_to raise_error
    end
  end
end
