require "concurrent/map"

module ActionView
  class DetailsKey #:nodoc:
    alias :eql? :equal?

    @details_keys = Concurrent::Map.new

    def self.get(details)
      if details[:formats]
        details = details.dup
        details[:formats] &= Template::Types.symbols
      end
      @details_keys[details] ||= Concurrent::Map.new
    end

    def self.view_context_class(klass)
      @view_context_class ||= klass.with_empty_template_cache
    end

    def self.clear
      @view_context_class = nil
      @details_keys.clear
    end

    def self.digest_caches
      @details_keys.values
    end
  end
end
