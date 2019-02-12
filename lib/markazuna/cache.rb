require 'redis'
require 'redis-namespace'
require 'singleton'

module Markazuna
    class Cache
        include Singleton # mixin the singleton module

        def initialize
            @redis  = Redis::Namespace.new(:moslem_corner, :redis => Redis.new)
        end

        def set(key, value)
            @redis.set(key, value)
        end

        def get(key)
            @redis.get(key)
        end
    end

end