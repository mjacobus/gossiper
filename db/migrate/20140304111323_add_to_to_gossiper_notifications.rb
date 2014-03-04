class AddToToGossiperNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :to, :text
  end
end
