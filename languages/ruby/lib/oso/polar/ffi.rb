# frozen_string_literal: true

require 'ffi'

# helper method to generate result types
def result(result_klass)
  Class.new(::FFI::Struct) do
    layout :result, result_klass, :error, :string
  end.by_ref
end

module Oso
  module Polar
    module FFI
      LIB = "#{::FFI::Platform::LIBPREFIX}polar.#{::FFI::Platform::LIBSUFFIX}"
      RELEASE_PATH = File.expand_path(File.join(__dir__, "../../../ext/oso-oso/lib/#{LIB}"))
      DEV_PATH = File.expand_path(File.join(__dir__, "../../../../../target/debug/#{LIB}"))
      # If the lib exists in the ext/ dir, use it. Otherwise, fall back to
      # checking the local Rust target dir.
      LIB_PATH = File.file?(RELEASE_PATH) ? RELEASE_PATH : DEV_PATH

      # Wrapper classes defined upfront to fix Ruby loading issues. Actual
      # implementations live in the sibling `ffi/` directory and are `require`d
      # at the bottom of this file.

      # Wrapper class for Polar FFI pointer + operations.
      class Polar < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end
      # Wrapper class for Query FFI pointer + operations.
      class Query < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end
      # Wrapper class for QueryEvent FFI pointer + operations.
      class QueryEvent < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end
      # Wrapper class for Error FFI pointer + operations.
      class Error < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end
      # Wrapper class for Message FFI pointer + operations.
      class Message < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end

      # Wrapper class for Source FFI pointer.
      class Source < ::FFI::AutoPointer
        def self.release(ptr)
          Rust.free(ptr) unless ptr.null?
        end
      end

      # Defines the result type version of
      # each of these structs
      # result(T) => { result: T, error: string }
      CResultVoid = result(:int)
      CResultString = result(:string)
      CResultQuery = result(Query)
      CResultQueryEvent = result(QueryEvent)
      CResultMessage = result(Message)
      CResultSource = result(Source)
    end
    private_constant :FFI
  end
end

require 'oso/polar/ffi/polar'
require 'oso/polar/ffi/query'
require 'oso/polar/ffi/query_event'
require 'oso/polar/ffi/error'
require 'oso/polar/ffi/message'
require 'oso/polar/ffi/source'
