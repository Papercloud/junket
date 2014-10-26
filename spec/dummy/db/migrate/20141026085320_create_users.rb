class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :mobile
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
