class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, unique: true, index: true
      t.string :password_digest
      t.boolean :admin, default: false
      t.timestamp :verified_at, default: false
      t.string :verification_token, unique: true, index: true
      t.timestamp :verification_token_expiry_at
      t.string :forgot_password_token, unique: true, index: true
      t.timestamp :forgot_password_token_expiry_at
      t.string :remember_me_token, unique: true, index: true
      t.timestamps null: false
    end
  end
end
