require 'lib/endeca'
class Listing < Endeca::Document
  path 'http://192.168.3.218:8888/bridge/JSONControllerServlet.do'

  reader \
    :address,
    :contact,
    :description,
    :header,
    :phone

  integer_reader \
    'RecordSpec' => :listing_id

  float_reader \
    :longitude,
    :latitude

  decimal_reader :rent => :price

  boolean_reader :showemail => :show_email?

  reader(:rh_url => :details_url) {|url| "/{url}"}

  add_reader(:caret_delimited_reader) {|string| string.split('^+^')}

  caret_delimited_reader \
    :thumbnails,
    :graphicurl => :graphic_urls

  def coordinates; [latitude, longitude] end
  def image_url; (graphic_urls || thumbnails).first rescue nil end
end
