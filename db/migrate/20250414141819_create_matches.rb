class CreateMatches < ActiveRecord::Migration[8.0]
  def change
    create_table :matches do |t|
      t.references :player1, null: false, foreign_key: { to_table: :players }
      t.references :player2, null: false, foreign_key: { to_table: :players }
      t.datetime :start_time
      t.datetime :end_time
      t.references :winner, foreign_key: { to_table: :players }
      t.integer :table_number

      t.timestamps
    end
  end
end
