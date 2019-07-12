class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.references :label, foreign_key: true
      t.references :phoneable, polymorphic: true
      t.string :number
      t.boolean :confirmed

      t.timestamps
    end
  end
end
