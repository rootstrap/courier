module Courier
  class Middleware
    def initialize(app, options = {})
      @app = app
      @deep_link_base = options[:deep_link_base]
    end

    def call(env)
      request = Rack::Request.new(env)
      return deep_link_redirect(request) if deep_link_request?(request)

      @app.call(env)
    end

    def deep_link_redirect(request)
      fullpath = request.fullpath.gsub(/^\/courier\//,'')
      location = "#{@deep_link_base}://#{fullpath}"
      [
        301,
        { 'Location' => location, 'Content-Type' => 'text/html'},
        ['Courier: Redirecting to DeepLink']
      ]
    end

    def deep_link_request?(request)
      request.path_info =~ /^\/courier\//i
    end
  end
end
