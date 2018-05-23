module Courier
  class Request < ::Rack::Request
    def initialize(env)
      super(env)
    end

    def require_redirect?
      deep_link_request? && mobile_request?
    end

    def mobile_request?
      self.user_agent =~ Courier.configuration.regex_ua_mobile
    end

    def deep_link_request?
      self.path_info.match(Courier.configuration.regex_mounted_at) && !is_check?
    end

    def is_check?
      self.path_info.match(Courier.configuration.regex_check)
    end

    def deeplink_redirect
      fullpath = self.fullpath.gsub(Courier.configuration.regex_mounted_at, '')

      "#{Courier.configuration.deep_link_base}://#{fullpath}"
    end
  end
end
