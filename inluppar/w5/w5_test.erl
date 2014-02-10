-module(w5_test).
-export([test_LVT/0, test_packet/0]).
test_LVT() ->
	X = ["hej", 123, 1.13],
	["hej", 123, 1.13] = w5:decode_seq(w5:encode_seq(X)),
	horray.
	
test_packet() ->
	"hej" = w5:packet_to_term(w5:term_to_packet("hej")),
	"hej123" = w5:packet_to_term(w5:packet_to_binary((w5:binary_to_packet(w5:term_to_packet("hej123"))))),
	1255626 = w5:packet_to_term_with_checksum(w5:term_to_packet_with_checksum(1255626)),
	sweet.