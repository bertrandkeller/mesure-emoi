require 'jekyll/localization'
require 'jekyll/pagination'

module Jekyll
  # restore standard paths
  class Page

    def url(lang = nil)
      _localization_original_url
    end

    def destination(dest)
      _localization_original_destination(dest)
    end

    def process(name)
      _localization_original_process(name)
    end
    
    # restore standard paths
        %w[url destination process].each { |name|
          alias_method name, "_localization_original_#{name}"
    }

  end
end


