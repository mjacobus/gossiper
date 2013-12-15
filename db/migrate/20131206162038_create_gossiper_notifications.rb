class CreateGossiperNotifications < ActiveRecord::Migration
  def change
    create_table :gossiper_notifications do |t|
      t.integer :user_id
      t.string :user_type
      t.string :kind
      t.string :status
      t.datetime :delivered_at
      t.boolean :read

      t.timestamps
    end
  end
end
