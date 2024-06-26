# frozen_string_literal: true

module ClientInfo
  class << self
    def name
      "Sign Junkie Workshop"
    end

    def owner
      "Sign Junkie, LLC"
    end

    def address_1
      "11235 Ridenour Rd"
    end

    def address_2
      nil
    end

    def state
      "OH"
    end

    def city
      "Thornville"
    end

    def zip_code
      "43076-9690"
    end

    def domain
      "signjunkieworkshop.com"
    end

    def contact_email
      "martha@#{domain}"
    end

    def admin_email
      "martha@#{domain}"
    end

    def instagram_link
      "https://www.instagram.com/signjunkiediy/"
    end

    def facebook_link
      "https://www.facebook.com/signjunkieworkshop/"
    end
  end
end
