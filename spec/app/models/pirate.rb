class Pirate < ActiveRecord::Base
  acts_as_has_and_belongs_to_many :parrots,
    :before_add     => :log_before_add,
    :after_add      => :log_after_add,
    :before_remove  => :log_before_remove,
    :after_remove   => :log_after_remove
    # :before_create  => :log_before_create,
    # :after_create   => :log_after_create,
    # :before_destroy => :log_before_destroy,
    # :after_destroy  => :log_after_destroy
  acts_as_has_and_belongs_to_many :books
  attr_accessible :name

  def ship_log
    @ship_log ||= []
  end

  private
    def log_before_add(record)
      log(record, "before_adding_method")
    end

    def log_after_add(record)
      log(record, "after_adding_method")
    end

    def log_before_remove(record)
      log(record, "before_removing_method")
    end

    def log_after_remove(record)
      log(record, "after_removing_method")
    end

    def log(record, callback)
      ship_log << "#{callback}_#{record.class.name.downcase}_#{record.id || '<new>'}"
    end
end