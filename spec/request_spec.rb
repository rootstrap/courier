RSpec.describe Courier::Request do
  before :each do
    Courier.configure do |config|
      config.deep_link_base = 'my-app'
    end
  end

  describe '#require_redirect?' do
    let(:iphone_user_agent) { 'Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3' }
    let(:web_user_agent)    { 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36' }
    let(:env) do
      {
        "PATH_INFO" => '',
        "HTTP_USER_AGENT" => '',
      }
    end

    it 'returns true for PATH matching the redirect pattern' do
      env['PATH_INFO'] = '/courier/something_that_matches?foo=var'
      env['HTTP_USER_AGENT'] = iphone_user_agent

      request = Courier::Request.new(env)

      expect(request.require_redirect?).to be_truthy
    end

    it 'returns false for PATH matching the redirect pattern but on web browser' do
      env['PATH_INFO'] = '/courier/something_that_matches?foo=var'
      env['HTTP_USER_AGENT'] = web_user_agent

      request = Courier::Request.new(env)

      expect(request.require_redirect?).to be_falsy
    end

    it 'returns false for PATHS not matching the redirect pattern' do
      env['PATH_INFO'] = '/something/else/var'
      env['HTTP_USER_AGENT'] = iphone_user_agent

      request = Courier::Request.new(env)

      expect(request.require_redirect?).to be_falsy
    end
  end
end
