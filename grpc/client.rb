require 'grpc'
require_relative 'exchange_services_pb'

stub = Exchange::ExchangeService::Stub.new('localhost:50051', :this_channel_is_insecure)

def get_exchange_rate(stub)
  begin
    message = stub.get_exchange_rate(Exchange::GetExchangeRateRequest.new(base: 'USD', quote: 'RUB')).rate
    p "Rate: #{message}"
  rescue GRPC::BadStatus => e
    abort "ERROR: #{e.message}"
  end
end

def stream_exchange_rate(stub)
  begin
    stub.get_exchange_rate_stream(Exchange::GetExchangeRateRequest.new(base: 'USD', quote: 'RUB')).each do |resp|
      p "Rate: #{resp.rate}"
    end
  rescue GRPC::BadStatus => e
    abort "ERROR: #{e.message}"
  end
end

stream_exchange_rate(stub)

#get_exchange_rate(stub)