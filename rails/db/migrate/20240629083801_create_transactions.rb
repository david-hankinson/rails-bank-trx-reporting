class CreateTransactions < ActiveRecord::Migration[7.1]

  def change
    create_table :transactions, id: false do |t|
      enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
      t.uuid :id, default: 'gen_random_uuid()'
      t.string :branch
      t.date :timestamp
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
    add_index :transactions, :branch
    add_index :transactions, :timestamp
  end
end
