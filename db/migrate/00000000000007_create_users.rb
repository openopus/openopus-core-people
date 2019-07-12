class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.references :person, foreign_key: true
      t.string :status
      t.string :uuid

      t.timestamps
    end
  end
end
