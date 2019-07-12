class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.references :label, foreign_key: true
      t.references :emailable, polymorphic: true
      t.string :address
      t.boolean :confirmed

      t.timestamps
    end
  end
end
