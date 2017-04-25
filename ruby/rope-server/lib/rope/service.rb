module Rope
  class Service

    class Model
      attr_reader :name

      class Field < Struct.new(:name, :type)
      end

      def initialize(name, definition)
        @name = name
        @definition = definition
      end

      def fields
        @definition.map { |name, type| Field.new(name, type) }
      end
    end

    class Interface
      class Action
        attr_reader :name

        class Arg < Struct.new(:name, :type)
        end

        class Response < Struct.new(:type)
        end

        def initialize(name, definition)
          @name = name
          @definition = definition
        end

        def async?
          @definition["async"] == true
        end

        def args
          @definition["args"].map { |name, type| Arg.new(name, type) }
        end

        def response
          Response.new(@definition["response"])
        end
      end

      def initialize(definition)
        @definition = definition
      end

      def actions
        @definition.map { |name, definition| Action.new(name, definition) }
      end
    end

    def initialize(path)
      @path = path
    end

    def name
      content.fetch("name")
    end

    def models
      content.fetch("models").map { |name, definition| Model.new(name, definition) }
    end

    def interface
      Interface.new(content.fetch("interface"))
    end

    def content
      @content ||= YAML.load_file(@path)
    end

  end
end
