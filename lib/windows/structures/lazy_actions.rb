module Windows
  module Structures
    class LazyActions
      attr_reader :allowed_actions, :actions_to_run

      def initialize(engine, actions_to_run)
        @allowed_actions = [:move, :undock, :focus]
        @actions_to_run  = actions_to_run.find_all {|k, v| @allowed_actions.include?(k) }
        @engine          = engine
      end

      def run
        @actions_to_run.each do |method, args|
          @engine.instance_eval do
            if args.instance_of?(TrueClass)
              self.send(method)
            else
              self.send(method,*args)
            end
          end
        end
      end
      
    end
  end
end