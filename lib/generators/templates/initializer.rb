# Use this hook to configure API keys, Android package info, iOS bundle info,
# and analytics info. Many of these configuration options are not required,
# and depend on how you you initialize FFS. Please check the README for more info.
# Full documentation for each configuration option can be found here:
# https://firebase.google.com/docs/reference/dynamic-links/link-shortener
FFS.configure do |config|
  # ==> General configuration
  # Configure the project ID associated with your Firebase project.
  # You can find your project ID in your project's Firebase console.
  config.firebase_api_key = 'api_key'

  # Optionally configure your Bitly API key to use Bitly link shortening,
  # instead of the default Firebase link shortening.
  # config.bitly_api_key = 'api_key'

  # Configure your Firebase project's Dynamic Links domain.
  # You can find this value in the Dynamic Links section of the Firebase console.
  config.dynamic_link_domain = 'dynamic_link_domain'

  # Configure the length of the generated short link.
  # Only needed when using the Firebase link shortener.
  # Allowed options are 'SHORT' and 'UNGUESSABLE'.
  config.suffix = 'SHORT'

  # ==> Android configuration

  # Configure the package name of the Android app to use to open the link.
  config.android_package_name = 'android_package_name'

  # Configure the link to open when the app isn't installed.
  # config.android_fallback_link = 'android_fallback_link'

  # Configure the versionCode of the minimum version of your app that can open the link.
  # config.android_min_version = 'android_min_version'

  # ==> iOS configuration
  # Configure the bundle ID of the iOS app to use to open the link.
  config.ios_bundle_id = 'ios_bundle_id'

  # Configure your app's App Store ID.
  config.ios_app_store_id = 'ios_app_store_id'

  # Configure the link to open when the app isn't installed.
  # config.ios_fallback_link = 'ios_fallback_link'

  # Configure the link to open on iPads when the app isn't installed.
  # config.ipad_fallback_link = 'ipad_fallback_link'

  # Configure the bundle ID of the iOS app to use on iPads to open the link.
  # config.ipad_bundle_id = 'ipad_bundle_id'

  # Configure your app's custom URL scheme, if defined to be something other than your app's bundle ID
  # config.custom_scheme = 'custom_scheme'

  # ==> Analytics configuration
  # Configure your Google Play analytics parameters.
  # config.utm_source = 'utm_source'
  # config.utm_medium = 'utm_medium'
  # config.utm_campaign = 'utm_campaign'
  # config.utm_term = 'utm_term'
  # config.utm_content = 'utm_content'
  # config.gclid = 'gclid'

  # Configure your iTunes Connect analytics parameters.
  # config.at = 'at'
  # config.ct = 'ct'
  # config.mt = 'mt'
  # config.pt = 'pt'
end
