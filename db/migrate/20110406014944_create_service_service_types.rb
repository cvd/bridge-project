class CreateServiceServiceTypes < ActiveRecord::Migration
  def self.up
    create_table :service_service_types do |t|
      t.references :service
      t.references :service_type

      t.timestamps
    end
  end

  def self.down
    drop_table :service_service_types
  end
end
