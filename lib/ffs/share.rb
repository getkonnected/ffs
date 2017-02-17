require 'json'
require 'net/http'
require 'uri'

module FFS
  class Share
    DEFAULT = {
      android: true,
      ios: true,
      min_package: false,
      ipad: false,
      custom_scheme: false,
      fallback: false,
      analytics: false
    }.freeze

    def generate_firebase_short_link(hash, **options)
      opts = DEFAULT.merge(options)
      uri = URI.parse("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{FFS.configuration.api_key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = { 'Content-Type' => 'application/json' }
      body = build_json_body(hash, opts)

      http.post(uri, body, headers).body
    end

    private

    def build_json_body(hash, opts)
      body = base_info
      body[:dynamicLinkInfo].merge!(hash)
      body[:dynamicLinkInfo][:androidInfo] = build_android_info(opts) if opts[:android]
      body[:dynamicLinkInfo][:iosInfo] = build_ios_info(opts) if opts[:ios]
      body[:dynamicLinkInfo][:analyticsInfo] = build_analytics_info(opts) if opts[:analytics]
      body.to_json
    end

    def base_info
      {
        dynamicLinkInfo: {
          dynamicLinkDomain: FFS.configuration.dynamic_link_domain
        },
        suffix: {
          option: FFS.configuration.suffix
        }
      }
    end

    def build_android_info(opts)
      android_info = {
        androidPackageName: FFS.configuration.android_package_name
      }

      android_info[:androidFallbackLink] = FFS.configuration.android_fallback_link if opts[:fallback]
      android_info[:androidMinPackageVersionCode] = FFS.configuration.android_min_version if opts[:min_package]
      android_info
    end

    def build_ios_info(opts)
      ios_info = {
        iosBundleId: FFS.configuration.ios_bundle_id,
        iosAppStoreId: FFS.configuration.ios_app_store_id
      }

      ios_info[:iosFallbackLink] = FFS.configuration.ios_fallback_link if opts[:fallback]
      ios_info[:iosCustomScheme] = FFS.configuration.custom_scheme if opts[:custom_scheme]
      build_ipad_info(ios_info, opts) if opts[:ipad]
      ios_info
    end

    def build_ipad_info(ios_info, opts)
      ios_info[:iosIpadBundleId] = FFS.configuration.ipad_bundle_id
      ios_info[:iosIpadFallbackLink] = FFS.configuration.ipad_fallback_link if opts[:fallback]
    end

    def build_analytics_info(opts)
      analytics = {}
      analytics[:googlePlayAnalytics] = build_google_play_analytics(body) if opts[:android]
      analytics[:itunesConnectAnalytics] = build_itunes_connect_analytics(body) if opts[:ios]
      analytics
    end

    def build_google_play_analytics
      {
        utmSource: FFS.configuration.utm_source,
        utmMedium: FFS.configuration.utm_medium,
        utmCampaign: FFS.configuration.utm_campaign,
        utmTerm: FFS.configuration.utm_term,
        utmContent: FFS.configuration.utm_content,
        gclid: FFS.configuration.gclid
      }
    end

    def build_itunes_connect_analytics
      {
        at: FFS.configuration.at,
        ct: FFS.configuration.ct,
        mt: FFS.configuration.mt,
        pt: FFS.configuration.pt
      }
    end
  end
end
