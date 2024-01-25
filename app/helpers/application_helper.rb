module ApplicationHelper
  require 'rqrcode'
  require 'chunky_png'
  require 'securerandom'

  def page_title(page_title = '')
    base_title = 'Scramoney'
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def display_family_name(family)
    (family.family_nickname.presence || "#{family.family_name} 家")
  end

  def show_qrcode(url, size)
    if Rails.env.production?
      qrcode = RQRCode::QRCode.new("https://scramoney-e5c31290853e.herokuapp.com#{url}")
    elsif Rails.env.development? || Rails.env.test?
      qrcode = RQRCode::QRCode.new("https://a0b5-115-37-180-231.ngrok-free.app#{url}")
    end
    ChunkyPNG::Image.from_datastream(qrcode.as_png.resize(size, size).to_datastream).to_data_url
  end

  def new_notice?
    Read.where(user_id: current_user.id, checked: false).present?
  end
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash_messages"
  end
end
