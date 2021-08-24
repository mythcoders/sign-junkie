# frozen_string_literal: true

class JsonHashieMash < Hashie::Mash
  class << self
    # takes an object and returns the value to be stored in the database
    def dump(obj)
      ActiveSupport::JSON.encode(obj.to_h)
    end

    # takes the database value and returns an instance of the specified class
    def load(input)
      hash = ActiveSupport::JSON.decode(input || "{}")
      new(hash || {})
    end
  end
end
