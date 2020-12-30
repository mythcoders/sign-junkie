class FrontendGuestParser
  def initialize(params)
    @params = params
  end

  def parse
    case @params.guest_type
    when 'child'
      child_owner_attributes
    when 'adult', 'other'
      adult_owner_attributes
    end
  end

  private

  def child_owner_attributes
    {
      seat_preference: item.seat_preference,
      first_name: @params.child_first_name,
      last_name: @params.child_last_name,
      parent: {
        first_name: @params.first_name,
        last_name: @params.last_name,
        email: @params.email
      }
    }
  end

  def adult_owner_attributes
    {
      seat_preference: item.seat_preference,
      first_name: @params.first_name,
      last_name: @params.last_name,
      email: @params.email
    }
  end
end
