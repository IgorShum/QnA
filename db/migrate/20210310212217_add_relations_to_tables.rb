class AddRelationsToTables < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user
    add_reference :questions, :user
  end
end
