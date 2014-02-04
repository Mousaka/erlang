-module(w5).
-export([encode_seq/1,decode_seq/1, binary_to_packet/1,
		packet_to_binary/1, term_to_packet/1, packet_to_term/1,
		packet_to_term_with_checksum/1, term_to_packet_with_checksum/1]).
-type seq() :: integer() | string() | float().

%%LTV ENCODING
-spec encode_seq([seq()]) -> binary().
encode_seq(L) ->
	encode_seq_help(L, []).

encode_seq_help([], R) ->
	list_to_binary(lists:reverse(R));
encode_seq_help([H|T], R) -> 
	if
		is_integer(H) -> 
			encode_seq_help(T, [encode_int(H)|R]);
		is_float(H) ->
			encode_seq_help(T, [encode_float(H)|R]);
		true ->
			encode_seq_help(T, [encode_string(H)|R])
	end.

	
encode_float(F) ->
	X = 3,
	<<X:8, 8:32/big-signed-integer, F:64/float>>.
	
encode_string(S) ->
	X = 1,
	Z = list_to_binary(S),
	Y = byte_size(Z),
	<<X:8, Y:32/big-signed-integer, Z/binary>>.
	
encode_int(I) -> 
	X = 2,
	<<X:8, 4:32/big-signed-integer,I:32/integer>>.

-spec decode_seq(binary()) -> [seq()].

decode_seq(B) ->
	decode_seq_help(B, []).
	
decode_seq_help(<<>>, R) -> lists:reverse(R);
decode_seq_help(<<X:8, Y:32/big-signed-integer, Z:Y/binary, Tail/binary>>, R) ->
	if
		X==2 ->
			decode_seq_help(Tail, [decode_int(Z)|R]);
		X==1 ->
			decode_seq_help(Tail, [decode_string(Z)|R]);
		X==3 ->
			decode_seq_help(Tail, [decode_float(Z)|R])
	end.			

decode_int(<<X:32/integer>>) ->
	X.
decode_string(X) ->
	binary_to_list(X).
decode_float(<<X:64/float>>) ->
	X.

	%%PACKET MANIPULATION

-spec binary_to_packet(binary())-> binary().
binary_to_packet(B) ->
			N = byte_size(B),
			<<N:32/big-integer-signed, B/binary>>.


-spec packet_to_binary(binary())-> binary().
packet_to_binary(<<_:32/big-integer, B/binary>>) ->
		B.

-spec term_to_packet(term())->binary().
term_to_packet(Term) ->
			B = term_to_binary(Term),
			binary_to_packet(B).
			
-spec packet_to_term(binary()) -> any().
packet_to_term(Packet) ->
	B1 = packet_to_binary(Packet),
	binary_to_term(B1).

-spec term_to_packet_with_checksum(any()) -> binary().
term_to_packet_with_checksum(Term) ->
	T1 = term_to_binary(Term),
	C = erlang:crc32(T1),
	N = byte_size(T1),
	<<N:32/big-integer-signed, C:32/big-integer, T1/binary>>.

-spec packet_to_term_with_checksum(binary()) -> any().
packet_to_term_with_checksum(<<_:32/big-integer-signed, C:32/big-integer, B/binary>>) ->
	Check = erlang:crc32(B),
	B1 = binary_to_term(B),	
	if
		C == Check ->
			B1;
		true ->
			"Corrupted data!"
	end.