class CreateValidationModels < ActiveRecord::Migration
  def change
    create_table :cross_validations do |t|
      t.string :name
      t.integer :k
      t.integer :metric
      t.integer :dataset_size
      t.integer :list_size
      t.float :score, default: 0
      t.integer :status, default: 0
      t.timestamps
    end

    create_table :folds do |t|
      t.integer :cross_validation_id
      t.integer :run
      t.integer :set_size
      t.float :score, default: 0
    end
  end
end
