class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.attachment :data
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
