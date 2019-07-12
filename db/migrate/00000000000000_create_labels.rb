class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :value
      t.string :lang

      t.timestamps
    end
  end
end
