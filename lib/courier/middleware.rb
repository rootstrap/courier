module Courier
  class Middleware
    def initialize(app, options = {})
      @app = app
    end

    def call(env)
      request = Courier::Request.new(env)
      return deep_link_redirect(request) if request.require_redirect?
      return user_check(request) if request.is_check?
      @app.call(env)
    end

    def user_check(request)
      signature = UserSignatureService.find(request)
      signature ? found(signature) : not_found
    end

    def found(signature)
      [
        200,
        {
          'Content-Type' => 'application/json'
        },
        [
          '{ "status": "found" }'
        ]
      ]
    end

    def not_found
      [
        404,
        {
          'Content-Type' => 'application/json'
        },
        [
          '{ "status": "not_found" }'
        ]
      ]
    end

    def deep_link_redirect(request)
      [
        301,
        {
          'Location' => request.deeplink_redirect,
          'Content-Type' => 'text/html',
          'Content-Length' => '0'
        },
        []
      ]
    end
  end
end
