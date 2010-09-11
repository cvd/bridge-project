class User
  include MongoMapper::Document

  key :collected_services, Array
  timestamps!
  
end
