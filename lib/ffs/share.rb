# https://firebase.google.com/docs/reference/dynamic-links/link-shortener

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

    def generate_link(**options)
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
      json = base_json
      json = build_android_json(json, opts) if opts[:android]
      json = build_ios_json(json, opts) if opts[:ios]
      json = build_analytics_json(json, opts) if opts[:analytics]
      json.to_json
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

    def build_android_json(json, opts)
      json[:androidInfo] = {
        androidPackageName: FFS.configuration.android_package_name,
        androidFallbackLink: FFS.configuration.android_fallback_link,
        androidMinPackageVersionCode: FFS.configuration.android_min_version
      }

      json[:androidInfo].delete(:androidFallbackLink) unless opts[:fallback]
      json[:androidInfo].delete(:androidMinPackageVersionCode) unless opts[:min_package]
      json
    end

    def build_ios_json(json, opts)
      json[:iosInfo] = {
        iosBundleId: FFS.configuration.ios_bundle_id,
        iosFallbackLink: FFS.configuration.ios_fallback_link,
        iosCustomScheme: FFS.configuration.custom_scheme,
        iosIpadFallbackLink: FFS.configuration.ipad_fallback_link,
        iosIpadBundleId: FFS.configuration.ipad_bundle_id,
        iosAppStoreId: FFS.configuration.ios_app_store_id
      }

      json[:iosInfo].delete(:iosFallbackLink) unless opts[:fallback]
      json[:iosInfo].delete(:iosCustomScheme) unless opts[:custom_scheme]
      json[:iosInfo].delete(:iosIpadFallbackLink) unless opts[:ipad] && opts[:fallback]
      json[:iosInfo].delete(:iosIpadBundleId) unless opts[:ipad]
      json
    end

    def build_analytics_json(json, opts)
      json[:analyticsInfo] = {
        googlePlayAnalytics: {
          utmSource: FFS.configuration.utm_source,
          utmMedium: FFS.configuration.utm_medium,
          utmCampaign: FFS.configuration.utm_campaign,
          utmTerm: FFS.configuration.utm_term,
          utmContent: FFS.configuration.utm_content,
          gclid: FFS.configuration.gclid
        },
        itunesConnectAnalytics: {
          at: FFS.configuration.at,
          ct: FFS.configuration.ct,
          mt: FFS.configuration.mt,
          pt: FFS.configuration.pt
        }
      }

      json[:analyticsInfo].delete(:googlePlayAnalytics) unless opts[:android]
      json[:analyticsInfo].delete(:itunesConnectAnalytics) unless opts[:ios]
      json
    end
  end
end
