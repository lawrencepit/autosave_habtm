#
# TODO: validations?
#

module Copa
  module Acts
    class HasAndBelongsToManyAutosaveAssociation < ActiveRecord::Associations::HasAndBelongsToManyAssociation #:nodoc:
      def reset_links
        @links.each { |record| record.send(:mark_as_linked, nil) } if @links
        @unlinks.each { |record| record.send(:mark_as_linked, nil) } if @unlinks
        @links = @unlinks = nil
      end

      def reset_target!
        @target = Array.new
        reset_links
      end

      def reset
        super
        reset_target!
      end

      # Add +records+ to this association.  Returns +self+ so method calls may be chained.
      # Since << flattens its argument list and inserts each record, +push+ and +concat+ behave identically.
      def <<(*records)
        load_target
        flatten_deeper(records).compact.each do |record|
          raise_on_type_mismatch(record)
          add_record_to_target_with_callbacks(record)
        end
        self
      end
      alias_method :push, :<<
      alias_method :concat, :<<

      # Clears the records from the association, without deleting them from the datastore yet.
      # When the owner of this association is saved the given records will be deleted.
      def delete(*records)
        load_target
        flatten_deeper(records).compact.each do |record|
          unless @target.delete(record).nil?
            callback(:before_remove, record)
            unlinks << record
            links.delete(record)
            record.send(:mark_as_linked, false)
            callback(:after_remove, record)
          end
        end
        self
      end

      # Clears all records from the association, without deleting them from the datastore yet.
      # When the owner of this association is saved the records will be deleted.
      def clear
        load_target
        delete(@target)
        self
      end

      def delete_all
        load_target
        delete(@target)
        reset_target!
      end

      def size
        load_target.size
      end

      def links
        @links ||= []
      end
      alias_method :pending_creates, :links

      def unlinks
        @unlinks ||= []
      end
      alias_method :pending_deletes, :unlinks

      # Saves the pending changes to the datastore.
      def save
        return unless @links || @unlinks
        transaction do
          if @links && @links.length > 0
            @links.each do |record|
              callback(:before_create, record)
              insert_record(record, false, false)
              callback(:after_create, record)
            end
          end
          if @unlinks && @unlinks.length > 0
            if @reflection.options[:dependent] == :destroy
              @unlinks.each do |record|
                callback(:before_destroy, record)
                delete_record(record, false, false)
                callback(:after_destroy, record)
              end
            else
              @unlinks.each { |record| callback(:before_destroy, record) }
              delete_records(@unlinks)
              @unlinks.each { |record| callback(:after_destroy, record) }
            end
          end
        end
        reset_links
      end

      protected
        def load_target
          @target = find_target unless loaded? || @owner.new_record?
          loaded if @target
          @target
        end

      private

        def add_record_to_target_with_callbacks(record)
          load_target
          callback(:before_add, record)
          yield(record) if block_given?
          unless @reflection.options[:uniq] && @target.include?(record)
            @target << record
            links << record
            unlinks.delete(record)
            record.send(:mark_as_linked, true)
          end
          callback(:after_add, record)
          record
        end

    end
  end
end

