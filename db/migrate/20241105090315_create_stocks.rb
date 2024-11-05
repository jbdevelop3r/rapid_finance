class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.integer :price
      t.integer :quantity
      t.integer :remaining_stock_count, default: 0

      t.timestamps
    end
  end
end
