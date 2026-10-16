class CreateVisitPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :visit_plans do |t|
      t.references :dog, null: false, foreign_key: true
      t.references :dog_run, null: false, foreign_key: true
      t.datetime :planned_at, null: false

      t.timestamps
    end
  end
end
