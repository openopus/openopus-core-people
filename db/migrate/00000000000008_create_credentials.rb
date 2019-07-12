class CreateCredentials < ActiveRecord::Migration[5.2]
  def change
    create_table :credentials do |t|
      t.references :credentialed, polymorphic: true
      t.references :email, foreign_key: true
      t.string :password_digest
      t.string :provider                # Like Google, Facebook, etc.
      t.string :provider_auth           # Whatever their auth token looks like.

      t.timestamps
    end
  end
end
