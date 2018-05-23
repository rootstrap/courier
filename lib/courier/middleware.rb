module Courier
  class Middleware
    def initialize(app, options = {})
      @app = app
      @deep_link_base = options[:deep_link_base]
      @regex_ua_mobile = Regexp.new('palm|blackberry|nokia|phone|midp|mobi|symbian|' +
        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
        'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
        'chtml|ericsson|minimo|mobile', true)
      @regex_mounted_at = options[:mounted_at] || /^\/courier\//
    end

    def call(env)
      request = Rack::Request.new(env)
      return deep_link_redirect(request) if require_redirect?(request)
      @app.call(env)
    end

    def deep_link_redirect(request)
      fullpath = request.fullpath.gsub(@regex_mounted_at, '')
      location = "#{@deep_link_base}://#{fullpath}"

      [
        301,
        {
          'Location' => location,
          'Content-Type' => 'text/html',
          'Content-Length' => '0'
        },
        []
      ]
    end

    def require_redirect?(request)
      deep_link_request?(request) && mobile_request?(request)
    end

    def mobile_request?(request)
      request.user_agent =~ @regex_ua_mobile
    end

    def deep_link_request?(request)
      request.path_info =~ @regex_mounted_at
    end
  end
end
