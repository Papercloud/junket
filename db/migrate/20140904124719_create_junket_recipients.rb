class CreateJunketRecipients < ActiveRecord::Migration
  def change
    create_table :junket_recipients do |t|
      t.references :target, polymorphic: true, index: true
      t.references :campaign, index: true

      t.timestamps
    end
  end
end
