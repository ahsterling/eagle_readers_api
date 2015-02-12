class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string   "email"
      t.datetime "created_at",                          null: false
      t.datetime "updated_at",                          null: false
      t.string   "encrypted_password",     default: "", null: false
      t.string   "reset_password_token"
      t.datetime "reset_password_sent_at"
      t.datetime "remember_created_at"
      t.integer  "sign_in_count",          default: 0,  null: false
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.inet     "current_sign_in_ip"
      t.inet     "last_sign_in_ip"
      t.string   "provider"
      t.string   "uid",                    default: "", null: false
      t.string   "name"
      t.string   "nickname"
      t.string   "image"
      t.text     "tokens"

      t.timestamps null: false


    end

    add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
    add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

  end
end
