class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :role, default: "user"
      t.string :name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
