class AddDataToNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :data, :string
  end
end
