class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports, id: false do |t|
      enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
      t.uuid :id, default: 'gen_random_uuid()'
      t.date :month
      t.json :data

      t.timestamps
    end
    add_index :reports, :month
  end
end
