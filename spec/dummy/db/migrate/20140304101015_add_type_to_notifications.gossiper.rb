# This migration comes from gossiper (originally 20140304100755)
class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :type, :string
  end
end
