require 'rails/generators'

module FireShare
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      desc 'Creates FireShare initializer for your application'

      def copy_initializer
        template 'initializer.rb', 'config/initializers/fire_share.rb'
      end

      def show_readme
        readme 'README'
      end
    end
  end
end
