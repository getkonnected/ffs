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

    def generate_short_link(**options)
      opts = DEFAULT.merge(options)
      uri = URI.parse("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{FFS.configuration.api_key}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      headers = { 'Content-Type' => 'application/json' }
      body = build_json_body(opts)

      http.post(uri, body, headers).body
    end

    private

    def build_json_body(opts)
      body = base_json
      body = build_android_info(body, opts) if opts[:android]
      body = build_ios_info(body, opts) if opts[:ios]
      body = build_analytics_info(body, opts) if opts[:analytics]
      body.to_json
    end

    def base_json
      {
        dynamicLinkInfo: {
          dynamicLinkDomain: FFS.configuration.dynamic_link_domain,
          link: 'http://www.diviup.org',
          socialMetaTagInfo: {
            socialTitle: 'title',
            socialDescription: 'description',
            socialImageLink: 'link'
          }
        },
        suffix: {
          option: FFS.configuration.suffix
        }
      }
    end

    def build_android_info(body, opts)
      body[:dynamicLinkInfo][:androidInfo] = {
        androidPackageName: FFS.configuration.android_package_name
      }

      body[:dynamicLinkInfo][:androidInfo][:androidFallbackLink] = FFS.configuration.android_fallback_link if opts[:fallback]
      body[:dynamicLinkInfo][:androidInfo][:androidMinPackageVersionCode] = FFS.configuration.android_min_version if opts[:min_package]
      body
    end

    def build_ios_info(body, opts)
      body[:iosInfo] = {
        iosBundleId: FFS.configuration.ios_bundle_id,
        iosAppStoreId: FFS.configuration.ios_app_store_id
      }

      body[:iosInfo][:iosFallbackLink] = FFS.configuration.ios_fallback_link if opts[:fallback]
      body[:iosInfo][:iosCustomScheme] = FFS.configuration.custom_scheme if opts[:custom_scheme]
      build_ipad_info(body, opts) if opts[:ipad]
      body
    end

    def build_ipad_info(body, opts)
      body[:iosInfo][:iosIpadBundleId] = FFS.configuration.ipad_bundle_id
      body[:iosInfo][:iosIpadFallbackLink] = FFS.configuration.ipad_fallback_link if opts[:fallback]
    end

    def build_analytics_info(body, opts)
      build_google_play_analytics(body) if opts[:android]
      build_itunes_connect_analytics(body) if opts[:ios]
      body
    end

    def build_google_play_analytics(body)
      body[:analyticsInfo][:googlePlayAnalytics] = {
        utmSource: FFS.configuration.utm_source,
        utmMedium: FFS.configuration.utm_medium,
        utmCampaign: FFS.configuration.utm_campaign,
        utmTerm: FFS.configuration.utm_term,
        utmContent: FFS.configuration.utm_content,
        gclid: FFS.configuration.gclid
      }
    end

    def build_itunes_connect_analytics(body)
      body[:analyticsInfo][:itunesConnectAnalytics] = {
        at: FFS.configuration.at,
        ct: FFS.configuration.ct,
        mt: FFS.configuration.mt,
        pt: FFS.configuration.pt
      }
    end
  end
end
