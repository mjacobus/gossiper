class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :type, :string
  end
end
