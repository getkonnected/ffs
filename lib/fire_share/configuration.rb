module FireShare
  class Configuration
    attr_accessor :api_key, :dynamic_link_domain, :android_package_name,
                  :ios_bundle_id, :ios_app_store_id,
                  :social_title, :social_description, :social_image_link
  end
end
