require_relative 'logger'

module Babelyoda
  class Keyset
    attr_accessor :name
    attr_accessor :keys
    
    def self.keyset_name(filename)
      raise ArgumentError.new("Invlaid filename for a .strings file: #{filename}") unless filename.match(/\.strings$/)
      parts = File.join(File.dirname(filename), File.basename(filename, '.strings')).split('/')
      parts.delete_if { |part| part.match(/\.lproj$/) }
      File.join(parts)
    end
    
    def initialize(name)
      @name = name
      @keys = {}
    end
    
    def to_s ; "<#{self.class}: name = #{name}, keys.size = #{keys.size}>" ; end
    
    def debug_counts(languages = [])
      counts = languages.map do |language|
        count = 0
        keys.each_value do |key|
          count += 1 if key.values.has_key?(language)
        end
        count
      end
      $logger.debug "=== DEBUG COUNTS FOR: #{name} ==="
      languages.each_with_index do |language, index|
        $logger.debug "#{language}: #{counts[index]}"
      end
      $logger.debug "=== // DEBUG COUNTS FOR: #{name} ==="
    end
    
    def empty? ; keys.size == 0 ; end
    
    def merge!(keyset, options = {})
      result = { :new => 0, :updated => 0 }

      $logger.debug "Merging keyset '#{name}'"

      keyset.keys.each_pair do |id, key|
        isNew = false
        if @keys.has_key?(id)
          result[:updated] += 1 if @keys[id].merge!(key, options)
        else
          @keys[id] = key.dup
          result[:new] += 1
          isNew = true
        end

        $logger.debug "('#{id}', '#{key}') : #{idNew ? :new : :updated}"

      end
      return result
    end
    
    def merge_key!(localization_key)
      if @keys.has_key?(localization_key.id)
        @keys[localization_key.id].merge!(localization_key)
      else
        @keys[localization_key.id] = localization_key
      end
    end
    
    def ensure_languages!(languages = [])
      @keys.each_value do |key|
        key.ensure_languages!(languages)
      end
    end
    
    def drop_empty!
      @keys.delete_if do |id, key|
        key.drop_empty!
        key.empty?
      end
    end
  end
end
