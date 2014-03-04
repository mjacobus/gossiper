# This migration comes from gossiper (originally 20140304131816)
class RemoveKindFromGossiperNotifications < ActiveRecord::Migration
  def up
    remove_column :gossiper_notifications, :kind
  end

  def down
    add_column :notifications, :type, :string
  end

end
