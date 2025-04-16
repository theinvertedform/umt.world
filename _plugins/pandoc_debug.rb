Jekyll::Hooks.register :site, :after_init do |site|
  # Check if Pandoc is the converter
  markdown_converter = site.converters.find { |c| c.class.to_s.include?('Jekyll::Converters::Markdown') }

  if markdown_converter && markdown_converter.class.to_s.include?('Pandoc')
    Jekyll.logger.info "Pandoc Debug:", "Using Pandoc converter: #{markdown_converter.class}"

    # Try to access Pandoc configuration
    if site.config['pandoc'] && site.config['pandoc']['extensions']
      Jekyll.logger.info "Pandoc Debug:", "Extensions: #{site.config['pandoc']['extensions'].inspect}"

      # Check for Lua filter
      lua_filter = site.config['pandoc']['extensions'].find { |ext| ext.is_a?(Hash) && ext['lua-filter'] }
      if lua_filter
        Jekyll.logger.info "Pandoc Debug:", "Found Lua filter: #{lua_filter['lua-filter']}"
        # Check if file exists
        if File.exist?(lua_filter['lua-filter'])
          Jekyll.logger.info "Pandoc Debug:", "Lua filter file exists"
        else
          Jekyll.logger.error "Pandoc Debug:", "Lua filter file not found: #{lua_filter['lua-filter']}"
        end
      else
        Jekyll.logger.warn "Pandoc Debug:", "No Lua filter found in configuration"
      end
    else
      Jekyll.logger.warn "Pandoc Debug:", "No Pandoc extensions configured"
    end
  else
    Jekyll.logger.warn "Pandoc Debug:", "Not using Pandoc converter"
  end
end
