require 'grpc'
require_relative 'exchange_service'
require_relative 'protos/exchange_pb'

def start_grpc_server
  port = '0.0.0.0:50051'
  s = GRPC::RpcServer.new
  s.add_http2_port(port, :this_port_is_insecure)
  s.handle(ExchangeService)
  s.run_till_terminated
end

Thread.new { start_grpc_server }.join