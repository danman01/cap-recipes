Dir[File.join(File.dirname(__FILE__), 'hlds/*.rb')].sort.each { |lib| require lib }