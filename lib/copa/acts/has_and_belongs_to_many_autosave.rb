module Copa
  module Acts
    module HasAndBelongsToManyAutosave

      def self.included(klass)
        klass.extend ClassMethods
        klass.send(:include, InstanceMethods)
      end

      module ClassMethods
        def has_and_belongs_to_many_autosave(association_id, options = {}, &extension)
          options[:autosave] = true

          reflection = create_has_and_belongs_to_many_reflection(association_id, options, &extension)
          collection_accessor_methods(reflection, Copa::Acts::HasAndBelongsToManyAutosaveAssociation)
          add_association_callbacks(reflection.name, options)
          self.after_create { |record| record.send(reflection.name).save }
          self.after_update { |record| record.send(reflection.name).save }
          accepts_checkbox_values(association_id)
        end

        def accepts_checkbox_values(association_id)
          define_method("#{association_id}_checked=") do |ids|
            self.send("#{association_id.to_s.singularize}_ids=", [ids.split(',')])
          end
          attr_accessible :"#{association_id}_checked"
        end

        def accepts_nested_attributes_for_habtm_autosave(association_id)
          # :parrots_attributes => {:link => [1,4,5], :unlink => [2,3]}
          define_method("#{association_id}_attributes=") do |attributes|
            links = attributes[:link] || []
            unlinks = attributes[:unlink] || []
            links = links.split(',') if links.is_a?(String)
            unlinks = unlinks.split(',') if unlinks.is_a?(String)
            links.reject! {|link| link.blank?}
            unlinks.reject! {|unlink| unlink.blank?}
            ids = (links + unlinks).flatten.uniq
            if ids.length > 0
              association = self.send(association_id)
              records = association.proxy_reflection.klass.find(ids).inject({}) { |h, record| h[record.to_param] = record ; h }
              links.each { |id| association.concat(records[id.to_s]) }
              unlinks.each { |id| association.delete(records[id.to_s]) }
            end
          end
          attr_accessible :"#{association_id}_attributes"
        end

        def acts_as_has_and_belongs_to_many(association_id, options = {}, &extension)
          options[:uniq] ||= true
          options[:validate] ||= false
          has_and_belongs_to_many_autosave(association_id, options, &extension)
          #accepts_nested_attributes_for_habtm_autosave(association_id)
        end
      end

      module InstanceMethods
        def marked_as_linked?
          @marked_as_linked === true
        end

        def marked_as_unlinked?
          @marked_as_linked === false
        end

        private
          def mark_as_linked(linked)
            @marked_as_linked = linked
          end
      end
    end
  end
end
