class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :prefix, limit: 10
      t.string :fname
      t.string :minitial
      t.string :lname
      t.string :suffix, limit: 10
      t.string :birthdate
      t.string :nationality

      t.timestamps
    end
  end
end
