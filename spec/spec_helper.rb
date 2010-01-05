unless defined?(RAILS_ROOT)

  dir = File.dirname(__FILE__)
  require dir + "/test_app/spec/spec_helper"

  # log in the spec folder, not in the test_app
  ActiveRecord::Base.logger = Logger.new(dir + '/db/debug.log')

  # schema
  require dir + '/db/schema.rb'
  require dir + '/app/models/pirate.rb'
  require dir + '/app/models/parrot.rb'
  require dir + '/app/models/book.rb'

  # test data
  require dir + '/db/test_data.rb'

end
