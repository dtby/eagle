# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  def store_dir
    "system/uploads/#{convert_to_nice_date}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def convert_to_nice_date
    model.created_at.strftime("%Y/%m/%d")
  end

  def filename
    @name ||= "#{timestamp}.#{file.extension}" if original_filename.present? and super.present?
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def default_url
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end

  version :thumb do
    process resize_to_fill: [100,0]
  end

  version :w_640 do
    process resize_to_fill: [640,0]
  end

end
