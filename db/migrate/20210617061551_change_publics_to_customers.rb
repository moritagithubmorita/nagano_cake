class ChangePublicsToCustomers < ActiveRecord::Migration[5.2]
  def change
    rename_table :publics, :customers
  end
end
