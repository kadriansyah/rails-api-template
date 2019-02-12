module Markazuna
    module APICache
        def create_cache
            # # remove slash at beginning of uri "/admin/users" becomes "admin/users"
            # logger.info("#{self.request.original_fullpath[1..-1]} -- #{self.response.body}")

            # remove slash at beginning of uri "/admin/users" becomes "admin/users"
            strings = self.request.original_fullpath[1..-1].split('/')
            dirs = strings[0..strings.length - 2].join('/')
            path = "#{Rails.application.config.api_cache_directory}/#{dirs}"
            FileUtils::mkdir_p path
            cache_file = "#{path}/#{strings[strings.length - 1]}"
            open(cache_file, 'w') { |f|
                f << self.response.body
            }
        end
    end
end
