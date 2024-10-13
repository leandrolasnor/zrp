# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: alert.proto for package 'rpc'

require 'grpc'
require './lib/proto/app/proto/alert_pb'

module Rpc::Alert
  class Service
    include ::GRPC::GenericService

    self.marshal_class_method = :encode
    self.unmarshal_class_method = :decode
    self.service_name = 'rpc.Alert'

    rpc :Handle, ::Rpc::Occurrence, ::Rpc::Threat
  end

  Stub = Service.rpc_stub_class
end