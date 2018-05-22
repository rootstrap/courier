RSpec.describe Courier::Middleware do
  describe '#call' do
    let(:application) { double('Application') }
    let(:environment) { double('Environment') }
    let(:options) { { deep_link_base: 'my-app' } }
    let(:status) { double('status') }
    let(:headers) { double('headers') }
    let(:response) { double('response') }

    context 'when the request is for a deep link' do
      let(:environment) do
        {
          "PATH_INFO" => "/other_routes/more/things?foo=var",
        }
      end

      it 'passes the request thru' do
        expect(application)
          .to receive(:call)
          .with(environment)
          .and_return([status, headers, response])
        Courier::Middleware.new(application).call(environment)
      end
    end

    context 'when the request is for a deep link' do
      let(:environment) do
        {
          "PATH_INFO" => "/courier/invite?var1=foo1&var2=foo2",
        }
      end

      it 'responds with a redirect' do
        response = Courier::Middleware.new(application).call(environment)
        expect(response[0]).to eq(301)
      end

      it 'redirects to the configured deep link' do
        response = Courier::Middleware.new(application, options).call(environment)
        expect(response[1]['Location']).to match('my-app://invite?var1=foo1&var2=foo2')
      end
    end
  end
end
