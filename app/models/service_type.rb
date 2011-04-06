class ServiceType < ActiveRecord::Base
  has_many :service_service_types
  has_many :services, :through => :service_service_types
end
