module PublicHelper
  SORT_OPTIONS = {
    'Name: A-Z': 'A',
    'Name: Z-A': 'Z',
    'Date: Low to High': '1',
    'Date: High to Low': '9'
  }.freeze

  def checked_attr(value, desired)
    { checked: 'checked' } if value == desired || Hash.new
  end
end
