class Cart
  include MongoMapper::Document
  key :collected_services, Array, :default => []
  
  timestamps!
end
