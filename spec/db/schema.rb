ActiveRecord::Schema.define :version => 0 do
  create_table :pirates, :force => true do |t|
    t.string :name
  end

  create_table :parrots, :force => true do |t|
    t.string :name
  end

  create_table :books, :force => true do |t|
    t.string :name
  end

  create_table :parrots_pirates, :id => false, :force => true do |t|
    t.integer :parrot_id
    t.integer :pirate_id
  end

  create_table :books_pirates, :id => false, :force => true do |t|
    t.integer :book_id
    t.integer :pirate_id
  end
end
