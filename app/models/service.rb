class Service < ActiveRecord::Base
  has_many :service_service_types
  has_many :service_types, :through => :service_service_types
end

# == Schema Information
#
# Table name: services
#
#  id             :integer         not null, primary key
#  site_name      :string(255)
#  address        :string(255)
#  city           :string(255)
#  state          :string(255)
#  zip            :string(255)
#  phone          :string(255)
#  hours          :string(255)
#  transportation :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

