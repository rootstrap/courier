RSpec.describe Courier::UserSignatureService do
  xdescribe '.register' do
    it 'saves the request and all user information' do
    end

    it 'sets the created_at field' do
    end
  end

  xdescribe '.find' do
    it 'returns the available matching request' do
    end

    it 'returns a confidence % based on how many attributes matched' do
    end

    it 'does not return requests that are expired' do
      # configure block for allowed time (default 1 hour)
    end

    it 'returns false or nil when no request available' do
    end
  end
end
