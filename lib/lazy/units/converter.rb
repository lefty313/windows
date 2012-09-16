module Lazy
  module Units
    module Converter
      require 'lazy/core_ext/numeric'

      class Base 
        attr_reader :el, :options

        def initialize(el, options = {})
          @el      = el
          @options = options
        end

        def run
          raise "you must implement this method"
        end
      end

      module Formats
        class Percent < Base
          def run
            raise "you must specify options[:base] to change number to percent" unless options[:base]
            options[:base].percent(el)
          end
        end

        class Pixel < Base
          def run
            el
          end
        end

        SUPPORTED_FORMATS = {
          :percent => Percent,
          :pixel   => Pixel
        }

        def supported_formats
          SUPPORTED_FORMATS.keys
        end

        def format_for(format, *args)
          klass = SUPPORTED_FORMATS[format]
          raise "I only support this formats #{supported_formats}" unless klass
          klass.new(*args)
        end
      end

      class Finder < Struct.new(:el)
        include Formats

        def to(format, *args)
          format_for(format, el, *args).run
        end
      end

      def converter(el)
        @unit_converter ||= Finder.new(el)
        @unit_converter.el = el
        @unit_converter
      end
    end
  end
end