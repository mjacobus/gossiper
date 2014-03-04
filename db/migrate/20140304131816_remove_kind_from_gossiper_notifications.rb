class RemoveKindFromGossiperNotifications < ActiveRecord::Migration
  def up
    remove_column :gossiper_notifications, :kind
  end

  def down
    add_column :gossiper_notifications, :kind, :string
  end

end
