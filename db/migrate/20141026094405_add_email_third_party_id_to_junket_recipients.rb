class AddEmailThirdPartyIdToJunketRecipients < ActiveRecord::Migration
  def change
    add_column :junket_recipients, :email_third_party_id, :string
    add_index :junket_recipients, :email_third_party_id
  end
end
