# This migration comes from gossiper (originally 20131214081503)
class AddDataToNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :data, :text
  end
end
