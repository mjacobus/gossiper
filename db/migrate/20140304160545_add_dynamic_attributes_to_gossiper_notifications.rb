class AddDynamicAttributesToGossiperNotifications < ActiveRecord::Migration
  def change
    add_column :gossiper_notifications, :dynamic_attributes, :text
  end
end
