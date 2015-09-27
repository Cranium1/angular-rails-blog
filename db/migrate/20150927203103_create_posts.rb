class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :html
      t.text :markdown
      t.boolean :public
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
