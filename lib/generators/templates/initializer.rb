FireShare.configure do |config|
  config.api_key = 'api_key'
  config.dynamic_link_domain = 'dynamic_link_domain'
  config.suffix = 'SHORT'

  # Android
  config.android_package_name = 'android_package_name'
  config.android_fallback_link = 'android_fallback_link'
  config.android_min_version = 'android_min_version'

  # iOS
  config.ios_bundle_id = 'ios_bundle_id'
  config.ios_fallback_link = 'ios_fallback_link'
  config.ios_app_store_id = 'ios_app_store_id'
  config.ipad_fallback_link = 'ipad_fallback_link'
  config.ipad_bundle_id = 'ipad_bundle_id'
  config.custom_scheme = 'custom_scheme'

  # Analytics
  config.utm_source = 'utm_source'
  config.utm_medium = 'utm_medium'
  config.utm_campaign = 'utm_campaign'
  config.utm_term = 'utm_term'
  config.utm_content = 'utm_content'
  config.gclid = 'gclid'

  config.at = 'at'
  config.ct = 'ct'
  config.mt = 'mt'
  config.pt = 'pt'
end
