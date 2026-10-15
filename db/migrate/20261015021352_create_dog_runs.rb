class CreateDogRuns < ActiveRecord::Migration[8.0]
  def change
    create_table :dog_runs do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.time :opening_time, null: false
      t.time :closing_time, null: false
      t.boolean :indoor, null: false, default: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false

      t.timestamps
    end
  end
end
