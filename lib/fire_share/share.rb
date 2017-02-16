# https://firebase.google.com/docs/reference/dynamic-links/link-shortener

require 'net/http'
require 'uri'

module FireShare
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

    def generate_link(link_opts = {})
      opts = DEFAULT.merge(link_opts)

      uri = URI.parse("https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=#{FireShare.configuration.api_key}")
      http = Net::HTTP.new(uri.host, uri.port)
      headers = { 'Content-Type' => 'application/json' }
      body = build_json_body(opts)

      http.post(uri, body, headers).body
    end

    private

    def build_json_body(opts)
      json =
        {
          dynamicLinkInfo: {
            dynamicLinkDomain: FireShare.configuration.dynamic_link_domain,
            link: "http://www.diviup.org/#{obj.class.name.downcase.pluralize}/#{obj.id}",
            socialMetaTagInfo: {
              socialTitle: obj.name,
              socialDescription: obj.description,
              socialImageLink: obj.logo.thumbnail.url
            }
          },
          suffix: {
            option: FireShare.configuration.suffix
          }
        }

      json = build_android_json(json, opts) if opts[:android]
      json = build_ios_json(json, opts)
      json = build_analytics_json(json, opts)
      json
    end

    def build_android_json(json, opts)
      json.merge(
        androidInfo: {
          androidPackageName: FireShare.configuration.android_package_name,
          androidFallbackLink: FireShare.configuration.android_fallback_link,
          androidMinPackageVersionCode: FireShare.configuration.android_min_package_version_code,
        }
      )

      json.delete(:androidFallbackLink) unless opts[:fallback]
      json.delete(:androidMinPackageVersionCode) unless opts[:min_package]
      json
    end

    def build_ios_json(json, opts)
      json.merge(
        iosInfo: {
          iosBundleId: FireShare.configuration.ios_bundle_id,
          iosFallbackLink: 'string',
          iosCustomScheme: 'string',
          iosIpadFallbackLink: 'string',
          iosIpadBundleId: 'string',
          iosAppStoreId: FireShare.configuration.ios_app_store_id
        }
      )
    end

    def build_analytics_json(json, opts)
      json.merge(
        analyticsInfo: {
          googlePlayAnalytics: {
            utmSource: string,
            utmMedium: string,
            utmCampaign: string,
            utmTerm: string,
            utmContent: string,
            gclid: string
          },
          itunesConnectAnalytics: {
            at: string,
            ct: string,
            mt: string,
            pt: string
          }
        }
      )
    end
  end
end
