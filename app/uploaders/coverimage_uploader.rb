# encoding: utf-8

class CoverimageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [960,350]

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
