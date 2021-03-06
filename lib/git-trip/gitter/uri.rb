module GitTrip
  module Gitter

    # Handles fetching git repository information from a remote URI.
    class URI < Gitter::Base
      FORMATS   = %w{ json xml yaml }
      PROTOCOLS = %w{ http https }

      DEFAULTS = {
        :format => 'json'
      }

      # Takes a +uri+ that returns information about a repository;
      # expects JSON data by default (see FORMATS).
      # The second argument is an optional hash of +options+ (see DEFAULTS).
      #
      # <tt>options</tt> can contain:
      # * <tt>format</tt>: Defaults to 'json'; see FORMATS.
      def initialize(uri, options = {})
        raise Errors::InvalidURI if invalid_uri?(uri)
        @uri = uri
        @options = DEFAULTS.merge(options)
        raise Errors::InvalidFormat if invalid_format?(@options[:format])
        @repo = nil
        @data = {}
        fetch_repo
        setup_data_hash
      end

      private

      # Fetches repository information from the <tt>@uri</tt>.
      def fetch_repo
        @repo = case @options[:format]
        when 'json'
          JSON.parse(open(@uri).read).symbolize_keys
        end
        @repo[:commits].each { |h| h.symbolize_keys! if h.is_a? Hash }
      end

      # Returns true if the given +format+ is invalid.
      def invalid_format?(format)
        return true unless FORMATS.include?(format)
      end

      # Returns true if the given +uri+ is invalid.
      def invalid_uri?(uri)
        uri.grep(/^(#{PROTOCOLS.join('|')}):\/\/\w/).empty?
      end

      # Loads the <tt>@data</tt> hash with repository information.
      def setup_data_hash
        load_repo_commits
      end

      # Loads a hash of commits into <tt>@data[:commits]</tt>.
      def load_repo_commits
        commits = []
        @repo[:commits].each do |commit|
          commits << commit[:id]
        end
        @data[:commits] = commits
      end
    end # of URI

  end # of Gitter
end
