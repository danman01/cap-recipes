Dir[File.join(File.dirname(__FILE__), 'graphite/*.rb')].sort.each { |lib| require lib }