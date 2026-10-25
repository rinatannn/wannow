class FixDogRunCoordinatesPrecision < ActiveRecord::Migration[8.0]
  def change
    change_column :dog_runs, :latitude, :decimal, precision: 10, scale: 6, null: false
    change_column :dog_runs, :longitude, :decimal, precision: 10, scale: 6, null: false
  end
end