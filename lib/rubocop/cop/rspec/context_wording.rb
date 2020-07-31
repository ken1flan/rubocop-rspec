# frozen_string_literal: true

module RuboCop
  module Cop
    module RSpec
      # Checks that `context` docstring matches an allowed pattern.
      #
      # The default list of prefixes is minimal. Users are encouraged to tailor
      # the configuration to meet project needs. Other acceptable patterns may
      # include `^if`, `^unless`, `^for`, `^before`, `^after`, or `^during`.
      #
      # @see https://rspec.rubystyle.guide/#context-descriptions
      # @see http://www.betterspecs.org/#contexts
      #
      # @example `Patterns` configuration
      #
      #   # .rubocop.yml
      #   # RSpec/ContextWording:
      #   #   Patterns:
      #   #     - ^when\s
      #   #     - ^with\s
      #   #     - ^without\s
      #   #     - ^if\s
      #   #     - ^unless\s
      #   #     - ^for\s
      #
      # @example
      #   # bad
      #   context 'the display name not present' do
      #     # ...
      #   end
      #
      #   # good
      #   context 'when the display name is not present' do
      #     # ...
      #   end
      class ContextWording < Base
        MSG = 'Write context description like %<patterns>s.'

        DEPRECATED_KEY = 'Prefixes'
        DEPRECATION_WARNING =
          "Configuration key `#{DEPRECATED_KEY}` for #{cop_name} is " \
          'deprecated in favor of `Patterns`. Please use that instead.'

        def_node_matcher :context_wording, <<-PATTERN
          (block (send #rspec? { :context :shared_context } $(str #bad_pattern?) ...) ...)
        PATTERN

        def on_block(node)
          context_wording(node) do |context|
            add_offense(context,
                        message: format(MSG, patterns: joined_patterns))
          end
        end

        private

        def bad_pattern?(description)
          !united_pattern.match?(description)
        end

        def joined_patterns
          quoted = patterns.map { |pattern| "'#{pattern}'" }
          return quoted.first if quoted.size == 1

          quoted << "or #{quoted.pop}"
          quoted.join(', ')
        end

        def united_pattern
          p = patterns.map { |str| Regexp.new(str) }
          @united_pattern ||= Regexp.union(p)
        end

        def patterns
          ((cop_config['Patterns'] || []) + prefix_patterns).uniq
        end

        def prefix_patterns
          warn DEPRECATION_WARNING unless prefixes.empty?
          prefixes.map { |prefix| "^#{prefix}\\b" }
        end

        def prefixes
          cop_config['Prefixes'] || []
        end
      end
    end
  end
end
