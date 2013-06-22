class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :account
      t.string :repo
      t.text :chain_obj_notation

      t.timestamps
    end
  end
end
