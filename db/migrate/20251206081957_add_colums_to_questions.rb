class AddColumsToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :input_type, :string, null: false, default: "text"
    add_column :questions, :options, :json
    add_column :questions, :is_default, :boolean, null: false, default: false
  end
end
