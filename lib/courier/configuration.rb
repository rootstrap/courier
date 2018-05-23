module Courier
  class Configuration
    attr_accessor :deep_link_base, :regex_ua_mobile, :regex_mounted_at, :regex_check

    def initialize
      @deep_link_base = 'change-me'
      @regex_ua_mobile = Regexp.new('palm|blackberry|nokia|phone|midp|mobi|symbian|' +
        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
        'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
        'chtml|ericsson|minimo|mobile', true)
      @regex_mounted_at = /^\/courier\//
      @regex_check = "#{@regex_mounted_at}check"
    end
  end
end
