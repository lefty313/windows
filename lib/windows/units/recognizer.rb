module Windows
  module Units
    module Recognizer
      module Formats
        class Base < Struct.new(:el)
          attr_accessor :unit

          def match
            raise "you should implement your match"
          end

          def format
            self.class.to_s.split("::").last.downcase.to_sym
          end

          def return_match(matcher, data,&block)
            data = if data
              matcher.instance_eval &block
              matcher
            else
              nil
            end
          end
        end

        class Pixel < Base
          # match 50, 50.5, 50.02
          def match
            data = el.kind_of?(Numeric)
            item = return_match(self, data) { @unit = el }
          end
        end

        class Percent < Base
          # match 50px, 50PX, 50.5px, 50.1PX
          def match
            return false unless el.respond_to?(:match)

            data  = el.match(/(^[\d.]+)(%)/i)
            return_match(self, data) { @unit = Float(data[1]) }
          end
        end

        RECOGNIZERS = [Pixel, Percent]
      end

      class Finder < Struct.new(:el)
        include Formats

        def run
          item = RECOGNIZERS.map do |klass|
            recognizer = klass.new(el)
            recognizer.match
          end.compact.first

          raise "I don't know how to recognize this unit #{el}" unless item
          item
        end
      end

      def recognize_unit(el)
        @recognize_unit_engine ||= Finder.new
        @recognize_unit_engine.el = el
        @recognize_unit_engine.run
      end
    end
  end
end