class ServiceType < ActiveRecord::Base
  has_many :service_service_types
  has_many :service, :through => :service_service_types
end
