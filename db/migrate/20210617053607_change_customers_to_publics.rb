class ChangeCustomersToPublics < ActiveRecord::Migration[5.2]
  def change
    rename_table :customers, :publics
  end
end
