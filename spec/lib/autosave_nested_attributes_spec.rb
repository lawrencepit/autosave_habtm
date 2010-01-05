require File.dirname(__FILE__) + "/../spec_helper"

describe "has_and_belongs_to_many, :autosave => true" do

  it "should mass assign" do
    Pirate.accepts_nested_attributes_for_habtm_autosave :parrots
    p = Pirate.first
    p.parrots << [Parrot.first, Parrot.find(3), Parrot.last]
    p.save
    p = Pirate.first
    p.parrots_attributes = {:link => [1,4], :unlink => [2,3]}

    p.parrots.length.should == 3
    p.parrot_ids.sort.should == [1,4,5]

    p.save
    p = Pirate.first

    p.parrots.length.should == 3
    p.parrot_ids.sort.should == [1,4,5]
  end

  it "should mass assign with strings" do
    Pirate.accepts_nested_attributes_for_habtm_autosave :parrots
    p = Pirate.first
    p.parrots << [Parrot.first, Parrot.find(3), Parrot.last]
    p.save
    p = Pirate.first
    p.parrots_attributes = {:link => "1,4", :unlink => "2,3"}

    p.parrots.length.should == 3
    p.parrot_ids.sort.should == [1,4,5]

    p.save
    p = Pirate.first

    p.parrots.length.should == 3
    p.parrot_ids.sort.should == [1,4,5]
  end
end