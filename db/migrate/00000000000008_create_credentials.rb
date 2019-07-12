class CreateCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.references :credentialed, polymorphic: true
      t.references :email, foreign_key: true
      t.string :password
      t.string :password_digest
      t.string :provider
      t.string :uid

      t.timestamps
    end
  end
end
