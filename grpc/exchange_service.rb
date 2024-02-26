
require 'grpc'
require_relative 'exchange_services_pb'

class ExchangeService < Exchange::ExchangeService::Service
  def get_exchange_rate(exchange_req, _unused_call)
    Exchange::GetExchangeRateResponse.new(rate: 54)
  end

  def get_exchange_rate_stream(exchange_req, _unused_call)
    10.times.map do |i|
      Exchange::GetExchangeRateResponse.new(rate: i)
    end
  end
end
