# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email, limit: 60, null: false, default: ""
      t.string :name, limit: 60, null: false, default: ""
      t.string :nick_name, limit: 20, null: false, default: ""

      t.boolean :active, default: true
      t.boolean :admin, default: false

      t.boolean :customer_block, default: false
      t.boolean :customer_create, default: true
      t.boolean :customer_edit, default: true
      t.boolean :customer_delete, default: true

      t.boolean :project_block, default: false
      t.boolean :project_create, default: true
      t.boolean :project_edit, default: true
      t.boolean :project_delete, default: true      

      t.boolean :tag_block, default: false
      t.boolean :tag_create, default: true
      t.boolean :tag_edit, default: true
      t.boolean :tag_delete, default: true

      t.boolean :mark_block, default: false
      t.boolean :mark_create, default: true
      t.boolean :mark_edit, default: true
      t.boolean :mark_delete, default: true
      t.boolean :mark_finish, default: true

      t.boolean :user_block, default: true      

      t.boolean :request_create, default: true
      t.boolean :request_edit, default: true
      t.boolean :request_delete, default: true
      t.boolean :request_finish, default: true

      t.boolean :help_create, default: true
      t.boolean :help_edit, default: true
      t.boolean :help_delete, default: true

      t.bigint :position_id
      t.bigint :company_id, null: false
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
    add_foreign_key :users, :companies, index: true
    add_foreign_key :users, :positions, index: true
  end
end
