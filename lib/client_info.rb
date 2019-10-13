# frozen_string_literal: true

module ClientInfo
  class << self
    def name
      'Sign Junkie Workshop'
    end

    def owner
      'Sign Junkie, LLC'
    end

    def address_1
      '11235 Ridenour Rd'
    end

    def address_2
      nil
    end

    def state
      'OH'
    end

    def city
      'Thornville'
    end

    def zip_code
      '43076-9690'
    end

    def contact_email
      'signjunkie@columbus.rr.com'
    end

    def instagram_link
      'https://www.instagram.com/signjunkiediy/'
    end

    def facebook_link
      'https://www.facebook.com/signjunkieworkshop/'
    end

    def website_link
      'http://' + (ENV['GITLAB_ENVIRONMENT_URL'] || 'apollo.localhost')
    end
  end
end
