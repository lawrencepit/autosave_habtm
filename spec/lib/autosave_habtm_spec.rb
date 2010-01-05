require File.dirname(__FILE__) + "/../spec_helper"

describe "has_and_belongs_to_many, :autosave => true" do

  it "should have a pirate" do
    Pirate.first.name.should == "Pirate A"
  end

  it "should not be marked as linked" do
    Pirate.first.marked_as_linked?.should be_false
  end

  it "should add one" do
    p = Pirate.first
    p.parrots << Parrot.first
    p.parrots[0].marked_as_linked?.should be_true
  end

  it "should be marked as linked" do
    p = Pirate.first
    p.parrots << [Parrot.first, Parrot.last]
    p.parrots[0].marked_as_linked?.should be_true
  end

  it "should delay create" do
    p = Pirate.new(:name => "Pirate X")
    p.parrots << [Parrot.first, Parrot.last]
    p.books << [Book.first]
    Pirate.count.should == 5
    p.save
    Pirate.count.should == 6
    p = Pirate.find_by_name(p.name)
    p.parrots.size.should == 2
    p.books.size.should == 1
  end

  it "should delay update" do
    p = Pirate.first
    p.parrots << [Parrot.first, Parrot.last]
    p.books << [Book.first]
    Pirate.first.parrots.size.should == 0
    Pirate.first.books.size.should == 0
    p.save
    Pirate.first.parrots.size.should == 2
    Pirate.first.books.size.should == 1
  end

  it "should delay deletes" do
    p = Pirate.first
    p.parrot_ids = [2,3,4]
    p.book_ids = [1,3,4]
    p.save
    p = Pirate.first
    p.parrots.delete([Parrot.find(2), Parrot.find(4)])
    p.books.delete([Book.find(3)])
    Pirate.first.parrots.size.should == 3
    Pirate.first.books.size.should == 3
    p.save
    Pirate.first.parrots.size.should == 1
    Pirate.first.books.size.should == 2
  end

  it "should replace records" do
    p = Pirate.first
    p.parrots = [Parrot.first]
    p.parrots.length.should == 1
    p.parrots = [Parrot.first, Parrot.last]
    p.parrots.length.should == 2
    Pirate.first.parrots.length.should == 0
    p.save
    Pirate.first.parrots.length.should == 2
  end

  it "should replace ids" do
    p = Pirate.first
    p.parrots = [Parrot.first]
    p.parrot_ids = [Parrot.first.id, Parrot.last.id]
    p.parrots.length.should == 2
    Pirate.first.parrots.length.should == 0
    p.save
    p = Pirate.first
    p.parrots.length.should == 2
    p.parrots[0].should == Parrot.first
    p.parrots[1].should == Parrot.last
  end

  it "should return ids" do
    p = Pirate.first
    p.parrots = [Parrot.first, Parrot.last]
    p.parrot_ids.length.should == 2
    p.parrot_ids.should == [Parrot.first.id, Parrot.last.id]
    p.save
    p = Pirate.first
    p.parrot_ids.length.should == 2
    p.parrot_ids.should == [Parrot.first.id, Parrot.last.id]
  end

  it "should find one without loading collection" do
    p = Pirate.first
    p.parrots = [Parrot.first, Parrot.find(3)]
    p.save
    parrots = Pirate.first.parrots
    parrots.loaded?.should == false
    parrots.find(3).should ==  Parrot.find(3)
    parrots.first.should == Parrot.first
    parrots.last.should == Parrot.find(3)
    parrots.loaded?.should == false
  end

  it "should call before_add, after_add, before_remove, after_remove callbacks" do
    p = Pirate.first
    p.parrots = [Parrot.first, Parrot.find(3)]
    p.parrots.delete(p.parrots[0])
    p.ship_log.length.should == 6
    p.ship_log.should == ["before_adding_method_parrot_1", "after_adding_method_parrot_1", "before_adding_method_parrot_3", "after_adding_method_parrot_3", "before_removing_method_parrot_1", "after_removing_method_parrot_1"]
  end

  it "should build a new parrot" do
    p = Pirate.first
    p.parrots.build(:name => "Parrot X")
    p.ship_log.length.should == 2
    p.parrots[0].new_record?.should be_true
  end

  it "should create a new parrot" do
    p = Pirate.first
    p.parrots.create!(:name => "Parrot X")
    p.ship_log.length.should == 2
    p.parrots[0].new_record?.should be_false
  end

end
