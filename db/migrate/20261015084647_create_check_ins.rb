class CreateCheckIns < ActiveRecord::Migration[8.0]
  def change
    create_table :check_ins do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :dog_run, null: false, foreign_key: true
      t.datetime :checked_in_at, null: false
      t.datetime :checked_out_at

      t.timestamps
    end
  end
end
