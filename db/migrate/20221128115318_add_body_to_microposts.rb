class AddBodyToMicroposts < ActiveRecord::Migration[7.0]
  def change
    add_column :microposts, :body, :string
  end
end
