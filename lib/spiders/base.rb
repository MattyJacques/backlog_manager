# frozen_string_literal: true

module Spiders
  class Base < Tanakai::Base
    def self.parse!(handler, *args, **request)
      spider = new

      if args.present?
        spider.public_send(handler, *args)
      elsif request.present?
        spider.request_to(handler, **request)
      else
        spider.public_send(handler)
      end
    ensure
      spider.browser.quit
      #spider.browser&.destroy_driver!
    end
  end
end
