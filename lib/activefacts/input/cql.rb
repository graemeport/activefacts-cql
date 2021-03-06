#       Compile a CQL file into an ActiveFacts vocabulary.
#
# Copyright (c) 2009 Clifford Heath. Read the LICENSE file.
#
require 'activefacts/metamodel'
require 'activefacts/cql/parser'
require 'activefacts/cql/compiler'

module ActiveFacts
  module Input #:nodoc:
    # Compile CQL to an ActiveFacts vocabulary.
    # Invoke as
    #   afgen --<generator> <file>.cql
    class CQL
      EXTENSIONS = ['fiml', 'fidl', 'fiql', 'cql']
      # Read the specified file
      def self.readfile(filename)
        if EXTENSIONS.detect { |extension| File.basename(filename, extension) == "-" }
          read(STDIN, "<standard input>")
        else
          File.open(filename) {|file|
            read(file, filename)
          }
        end
      rescue => e
        # Augment the exception message, but preserve the backtrace
        ne = StandardError.new("In #{filename} #{e.message.strip}")
        ne.set_backtrace(e.backtrace)
        raise ne
      end

      # Read the specified input stream
      def self.read(file, filename = "stdin")
        readstring(file.read, filename)
      end 

      # Read the specified input string
      def self.readstring(str, filename = "string")
        compiler = ActiveFacts::CQL::Compiler.new(filename)
        compiler.compile(str)
      end 
    end
  end
end
