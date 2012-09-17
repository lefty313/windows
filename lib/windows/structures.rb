# load all files from structures dir
Dir[File.dirname(__FILE__) + '/structures/*.rb'].each {|file| require file }

module Windows
  module Structures
  end
end