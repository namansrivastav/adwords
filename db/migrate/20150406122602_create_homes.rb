class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :username
      t.attachment :data

      t.timestamps null: false
    end
  end
end
