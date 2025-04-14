class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.string :auth0_id
      t.string :name
      t.integer :ranking
      t.string :profile_picture_url

      t.timestamps
    end
    add_index :players, :auth0_id, unique: true
  end
end
