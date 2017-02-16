module FFS
  class Configuration
    attr_accessor :api_key, :dynamic_link_domain, :suffix,
                  :android_package_name, :android_fallback_link, :android_min_version,
                  :ios_bundle_id, :ios_fallback_link, :ios_app_store_id,
                  :ipad_fallback_link, :ipad_bundle_id, :custom_scheme,
                  :utm_source, :utm_medium, :utm_campaign, :utm_term, :utm_content, :gclid,
                  :at, :ct, :mt, :pt
  end
end
