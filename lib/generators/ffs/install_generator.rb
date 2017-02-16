require 'rails/generators'

module FFS
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)
      desc 'Creates FFS initializer for your application'

      def copy_initializer
        template 'initializer.rb', 'config/initializers/ffs.rb'
      end

      def show_readme
        readme 'README'
      end
    end
  end
end
