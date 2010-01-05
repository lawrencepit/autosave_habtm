# require all ruby files in this plugin
Dir.glob(File.dirname(__FILE__) + "/**/*.rb").each do |file|
  require file
end

ActiveRecord::Base.send(:include, Copa::Acts::HasAndBelongsToManyAutosave)
