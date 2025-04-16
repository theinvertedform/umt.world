module Jekyll
  module Converters
    class Markdown
      class Pandoc
        def initialize(config)
          Jekyll::External.require_with_graceful_fail "pandoc-ruby"
          @config = config["pandoc"] || {}
          Jekyll.logger.info "Pandoc:", "Initialized Pandoc converter with config: #{@config.inspect}"
        end

        def convert(content)
          extensions = @config['extensions'] || []
          format = @config['format'] || 'html5'

          # Log the Pandoc command
          Jekyll.logger.debug "Pandoc:", "Converting with extensions: #{extensions.inspect}"

          # Check for lua-filter in extensions
          lua_filter = extensions.find { |ext| ext.is_a?(Hash) && ext.key?('lua-filter') }
          if lua_filter
            Jekyll.logger.info "Pandoc:", "Using Lua filter: #{lua_filter['lua-filter']}"
          end

          ::PandocRuby.new(content, *extensions).send("to_#{format}")
        end
      end
    end
  end
end
