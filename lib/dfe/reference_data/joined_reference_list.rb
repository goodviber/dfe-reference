module DfE
  module ReferenceData
    ##
    #
    # A +JoinedReferenceList+ is a wrapper around one or more +ReferenceList+s with
    # disjoint (non-overlapping) ID ranges, which joins them all together into one
    # big one.

    # rubocop:disable Metrics/ParameterLists
    class JoinedReferenceList < ReferenceList
      def initialize(lists, schema: nil, list_description: nil, list_usage_guidance: nil, list_docs_url: nil, field_descriptions: nil)
        schema = lists[0].schema if schema.nil? && lists.length.positive?
        @lists = lists

        super(schema: schema,
              list_description: list_description,
              list_usage_guidance: list_usage_guidance,
              list_docs_url: list_docs_url,
              field_descriptions: field_descriptions)
      end
      # rubocop:enable Metrics/ParameterLists

      def all
        all = []
        @lists.each_entry do |list|
          all += list.all
        end
        all
      end

      def all_as_hash
        all = {}
        @lists.each_entry do |list|
          all.merge(list.all_as_hash)
        end
        all
      end

      def one(record_id)
        final_result = nil
        @lists.find do |list|
          result = list.one(record_id)
          if result.nil?
            false
          else
            final_result = result
            true
          end
        end
        final_result
      end
    end
  end
end
