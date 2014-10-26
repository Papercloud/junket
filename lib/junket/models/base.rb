require 'junket'

module Junket
  ##
  # Methods for invoking Junket in a model,
  # to configure use of targets and campaign owners.
  # Heavily inspired by geocoder's junket_options.
  #
  module Model
    module Base
      def junket_options
        if defined?(@junket_options)
          @junket_options
        elsif superclass.respond_to?(:junket_options)
          superclass.junket_options || {}
        else
          {}
        end
      end

      def junket_targetable
        fail
      end

      def junket_campaign_owner
        fail
      end

      private # ----------------------------------------------------------------

      def junket_init(options)
        @junket_options ||= {}
        @junket_options.merge! options
      end
    end
  end
end

