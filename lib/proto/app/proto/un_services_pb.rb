# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: un.proto for package 'rpc'

require 'grpc'
require './lib/proto/app/proto/un_pb'

module Rpc
  module UN
    class Service
      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'rpc.UN'

      rpc :Alert, ::Rpc::Occurrence, ::Rpc::Threat
    end

    Stub = Service.rpc_stub_class
  end
end
