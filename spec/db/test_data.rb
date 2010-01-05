ActiveRecord::Schema.define :version => 1 do
  Pirate.create!(:name => "Pirate A")
  Pirate.create!(:name => "Pirate B")
  Pirate.create!(:name => "Pirate C")
  Pirate.create!(:name => "Pirate D")
  Pirate.create!(:name => "Pirate E")

  Parrot.create!(:name => "Parrot A")
  Parrot.create!(:name => "Parrot B")
  Parrot.create!(:name => "Parrot C")
  Parrot.create!(:name => "Parrot D")
  Parrot.create!(:name => "Parrot E")

  Book.create!(:name => "Book A")
  Book.create!(:name => "Book B")
  Book.create!(:name => "Book C")
  Book.create!(:name => "Book D")
  Book.create!(:name => "Book E")
end
