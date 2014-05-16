module Pod
  class Specification
    class Linter
      class Results
        public

        class Result
          # @return [Symbol] the type of result.
          #
          attr_reader :type

          # @return [String] the message associated with result.
          #
          attr_reader :message

          # @param [Symbol] type    @see type
          # @param [String] message @see message
          #
          def initialize(type, message)
            @type    = type
            @message = message
            @platforms = []
          end

          # @return [Array<Platform>] the platforms where this result was
          #         generated.
          #
          attr_reader :platforms

          # @return [String] a string representation suitable for UI output.
          #
          def to_s
            r = "[#{type.to_s.upcase}] #{message}"
            if platforms != Specification::PLATFORMS
              platforms_names = platforms.uniq.map do |p|
                Platform.string_name(p)
              end
              r << " [#{platforms_names * ' - '}]" unless platforms.empty?
            end
            r
          end
        end

        def initialize
          @results = []
          @consumer = nil
        end

        # @return [Array<Result>] all of the generated results.
        #
        attr_reader :results

        # @return [Specification::Consumer] the current consumer.
        #
        attr_reader :consumer

        def consumer=(consumer)
          @consumer = consumer
        end

        # Adds an error result with the given message.
        #
        # @param  [String] message
        #         The message of the result.
        #
        # @return [void]
        #
        def error(message)
          add_result(:error, message)
        end

        # Adds a warning result with the given message.
        #
        # @param  [String] message
        #         The message of the result.
        #
        # @return [void]
        #
        def warning(message)
          add_result(:warning, message)
        end

        private

        def add_result(type, message)
          result = results.find { |r| r.type == type && r.message == message }
          unless result
            result = Result.new(type, message)
            results << result
          end
          result.platforms << @consumer.platform_name if @consumer
        end
      end
    end
  end
end
