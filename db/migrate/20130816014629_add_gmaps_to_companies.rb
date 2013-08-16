class AddGmapsToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :latitude, :float
    add_column :companies, :longitude, :float
    add_column :companies, :gmaps, :boolean
  end
end