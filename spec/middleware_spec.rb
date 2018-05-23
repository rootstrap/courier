RSpec.describe Courier::Middleware do
  describe '#call' do
    let(:iphone_user_agent) { 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3' }
    let(:web_user_agent) { 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36' }
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
          "HTTP_USER_AGENT" => 'ANY_USER_AGENT',
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
      context 'for a mobile user agent' do
        let(:environment) do
          {
            "PATH_INFO" => "/courier/invite?var1=foo1&var2=foo2",
            "HTTP_USER_AGENT" => iphone_user_agent,
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

      context 'for a web user agent' do
        let(:environment) do
          {
            "PATH_INFO" => "/courier/invite?var1=foo1&var2=foo2",
            "HTTP_USER_AGENT" => web_user_agent,
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
    end
  end
end
