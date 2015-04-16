# class CreateFiledets < ActiveRecord::Migration
#   def change
#     create_table :filedets do |t|
#     	t.string :name
#     	t.integer :num

#       t.timestamps null: false
#     end
#   end
# end

class CreateFiledets < ActiveRecord::Migration
  def change
    create_table :filedets do |t|
    	# t.integer :user_id
    	t.text :topadurl, array: true, default: '{}'
    	t.text :rightadurl, array: true, default: '{}'
    	t.text :normalurl, array: true, default: '{}'
    	t.string :totalsearch
    	t.text :pagedetail
    	t.string :getword
    	t.references :home, index: true
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
