class CreateRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :requests do |t|
      t.string :extractor_class
      t.string :account_id
      t.string :base_url
      t.jsonb :request_options
      t.jsonb :request_original_options
      t.jsonb :response_options
      t.string :request_cache_key
      t.jsonb :aux

      t.timestamps
    end
  end
end
