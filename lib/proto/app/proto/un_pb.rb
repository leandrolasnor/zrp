# frozen_string_literal: true

# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: un.proto

require 'google/protobuf'

descriptor_data = "\n\x08un.proto\x12\x03rpc\"W\n\nOccurrence\x12\x13\n\x0bmonsterName\x18\x01 \x01(\t\x12\x13\n\x0b\x64\x61ngerLevel\x18\x02 \x01(\t\x12\x1f\n\x08location\x18\x03 \x01(\x0b\x32\r.rpc.Location\"$\n\x08Location\x12\x0b\n\x03lat\x18\x01 \x01(\x01\x12\x0b\n\x03lng\x18\x02 \x01(\x01\"N\n\x06Threat\x12\x0c\n\x04name\x18\x01 \x01(\t\x12\x0c\n\x04rank\x18\x02 \x01(\t\x12\x0e\n\x06status\x18\x03 \x01(\t\x12\x0b\n\x03lat\x18\x04 \x01(\x01\x12\x0b\n\x03lng\x18\x05 \x01(\x01\x32+\n\x02UN\x12%\n\x05\x41lert\x12\x0f.rpc.Occurrence\x1a\x0b.rpc.Threatb\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Rpc
  Occurrence = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.Occurrence").msgclass
  Location = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.Location").msgclass
  Threat = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("rpc.Threat").msgclass
end
