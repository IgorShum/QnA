ActiveRecord::Schema.define(version: 2021_02_28_205752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'questions', force: :cascade do |t|
    t.string 'title'
    t.text 'body'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

end
