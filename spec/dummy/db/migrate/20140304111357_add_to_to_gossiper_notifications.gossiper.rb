# This migration comes from gossiper (originally 20140304111323)
class AddToToGossiperNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :to, :text
  end
end
