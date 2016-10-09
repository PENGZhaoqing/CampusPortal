CarrierWave.configure do |config|
  config.fog_credentials = {
      provider:              'AWS',                        # required
      aws_access_key_id:     ENV['S3_KEY'],                        # required
      aws_secret_access_key: ENV['S3_SECRET'],                        # required
      region:                'us-west-2',                  # optional, defaults to 'us-east-1'
      # host:                  'https://s3-us-west-2.amazonaws.com/campus-portal',             # optional, defaults to nil
      # endpoint:               'https://campus-portal.s3-ap-southeast-1.amazonaws.com'
  }
  config.fog_directory  = 'campus-portal'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" } # optional, defaults to {}
end