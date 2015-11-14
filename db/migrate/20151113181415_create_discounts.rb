class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :discount_code, null: false
      t.timestamp :begin_date
      t.timestamp :end_date
      t.integer :min_order, :default => 0
      t.string :operation, null: false
      t.integer :value, null: false
      t.integer :applicable_categories, array: true
      t.integer :applicable_modes, array: true
      t.timestamps null: false
    end
  end
end
