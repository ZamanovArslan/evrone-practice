# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: exchange.proto for package 'exchange'

require 'grpc'
require_relative 'protos/exchange_pb'

module Exchange
  module ExchangeService
    class Service

      include ::GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'exchange.ExchangeService'

      rpc :GetExchangeRate, ::Exchange::GetExchangeRateRequest, ::Exchange::GetExchangeRateResponse
      rpc :GetExchangeRateStream, ::Exchange::GetExchangeRateRequest, stream(::Exchange::GetExchangeRateResponse)
    end

    Stub = Service.rpc_stub_class
  end
end
