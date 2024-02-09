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

  def show_qrcode(path, size)
    if Rails.env.production?
      qrcode = RQRCode::QRCode.new("https://scramoney.fly.dev#{path}")
    elsif Rails.env.development? || Rails.env.test?
      qrcode = RQRCode::QRCode.new("https://a0b5-115-37-180-231.ngrok-free.app#{path}")
    end
    ChunkyPNG::Image.from_datastream(qrcode.as_png.resize(size, size).to_datastream).to_data_url
  end

  def new_notice?
    Read.where(user_id: current_user.id, checked: false).present?
  end
  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash_messages"
  end

  def default_meta_tags
    {
      site: 'Scramoney',
      title: 'お小遣いの奪い合いアプリ【Scramoney】',
      reverse: true,
      charset: 'utf-8',
      description: '家族や同居人とお互いの頑張りを認め合いながら、お小遣いをめぐって競い合うWebアプリです。',
      keywords: '',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('scramoney_icon.jpeg'),
        local: 'ja-JP'
      }
    }
  end
end
