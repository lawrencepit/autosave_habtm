class Parrot < ActiveRecord::Base
  has_and_belongs_to_many :pirates
end