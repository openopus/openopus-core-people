class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.references :label, foreign_key: true
      t.references :addressable, polymorphic: true
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :postal
      t.string :country
      t.float :lat
      t.float :lon
      t.boolean :confirmed

      t.timestamps
    end
  end
end
