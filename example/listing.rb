require 'lib/endeca'
class Listing < Endeca::Document
  path 'http://10.130.83.75:9888/bridge/JSONControllerServlet.do'

  reader \
    :country,
    :latitude,
    :longitude,
    :mda_code,
    :metro,
    :zipcode

  integer_reader \
    :deposit,
    :listing_id,
    :endeca_id

  boolean_reader \
    :isapartment => :apartment?

  add_reader :caret_delimited_array_reader do |value|
    value.split('^')
  end

end
