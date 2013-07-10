require 'active_support/core_ext/hash/conversions'

class Services
  class Base

    # The event fired by UserVoice
    attr_reader :event
      
    # The hash of configuration values
    attr_reader :data

    # The literal XML payload that would be generated by the UserVoice API
    attr_reader :api_xml

    def initialize(event, data, api_xml)
      @event, @data, @api_xml = event, data, api_xml
    end

    # Perform the service
    def perform
    end

    # Default implementation of message provided as a convenience. You don't
    # need to use this if it doesn't make sense for your service.
    def message
      if test_event?
        test_message
      end
    end

    # The message we send to test the configuration
    def test_message
      'Test message from UserVoice'
    end

    # True if we are just trying to test the configuration
    def test_event?
      event == 'test'
    end

    # A hash containing the all the data the service hook has access to
    def api_hash
      @api_data ||= Hash.from_xml(api_xml).values.first
      @api_data
    end
    
    # Declare the name of this service (takes a lambda for localization, if appropriate)
    def self.name(name)
      @name = name
    end

    def self.events_allowed(events)
      @events_allowed = events
    end

    # Declare a text field parameter (label and description both take a lambda for localization, if appropriate)
    def self.string(key, label, description="", hidden=false)
      field(:string, key, label, [], description, hidden)
    end

    def self.password(key, label, description="", hidden=false)
      field(:password, key, label, [], description, hidden)
    end

    # Declare a select parameter (label and description both take a lambda for localization, if appropriate)
    def self.option(key, label, options, description="", hidden=false)
      field(:select, key, label, options, description, hidden)
    end

    # Declare a checkbox parameter (label and description both take a lambda for localization, if appropriate)
    def self.boolean(key, label, description="", hidden=false)
      field(:checkbox, key, label, [], description, hidden)
    end

    def self.field(type, key, label, options, description, hidden=false)
      @fields ||= []
      @fields << {:type => type, :key => key.to_s, :label => label, :options => options, :description => description, :hidden => hidden}
    end

    def self.events
      %w[ new_ticket new_ticket_reply new_ticket_admin_reply new_suggestion new_comment new_kudo new_article new_forum suggestion_status_update ]
    end
  end
end
