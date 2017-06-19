class AddCaneditCanaddToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :can_edit, :boolean
    add_column :users, :can_add, :boolean
  end
end
