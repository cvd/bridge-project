class VolunteerOpportunity
  include MongoMapper::Document

  key :title, String
  key :description, String

  key :contact_name
  key :contact_email
  key :contact_phone

  belongs_to :service
end
