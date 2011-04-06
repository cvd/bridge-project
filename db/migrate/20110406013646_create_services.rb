class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :site_name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :hours
      t.string :transportation

      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
