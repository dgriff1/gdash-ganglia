require "bundler"
Bundler.require

require "gdash"

module GDash
  module Ganglia
    class << self
      def included klass
        klass.attr :embed, :default => true
        klass.attr :window
      end
    end

    SIZES = ["small", "medium", "large", "xlarge", "xxlarge"]

    def initialize *args, &block
      @size = "large"
      @embed = true
      super *args, &block
    end

    def size s = nil
      if s.nil?
        @size ||= "large"
      else
        raise ArgumentError.new("#{s.inspect} is not a valid Ganglia size") unless Ganglia::SIZES.include? s.to_s
        @size = s.to_s
      end
    end

    def size= s
      self.size s
    end

    def custom args = {}
      if args.blank?
        @custom ||= {}
      else
        @custom = (@custom || {}).merge args
      end
    end
  end
end

require "gdash/ganglia_graph"
require "gdash/ganglia_report"
require "gdash/ganglia_view"