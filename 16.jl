abstract type Packet end

struct LiteralPacket <: Packet
    version::Int
    value::Int
end

struct OperatorPacket <: Packet
    version::Int
    ptid::Int
    subpackets::Array{Packet,1}
end

mutable struct Parser
    bits::BitArray
    cursor::Int
end

function readint(parser::Parser, n_bits::Int)::Int
    value = 0
    for i = 0:n_bits-1
        value = 2 * value + parser.bits[parser.cursor]
        parser.cursor += 1
    end
    return value
end

function parse_packet(parser::Parser)::Packet
    version = readint(parser, 3)
    ptid = readint(parser, 3)
    if ptid == 4
        return parse_literal(parser, version)
    else
        return parse_operator(parser, version, ptid)
    end
end

function parse_literal(parser::Parser, version::Int)::LiteralPacket
    value = 0
    while true
        group = readint(parser, 5)
        value = 16 * value + group % 16
        group < 16 && return LiteralPacket(version, value)

    end
end

function parse_operator(parser::Parser, version::Int, ptid::Int)::OperatorPacket
    ltid = readint(parser, 1)
    subpackets = Array{Packet,1}()
    if ltid == 0
        total_length = readint(parser, 15)
        old_cursor = parser.cursor
        while parser.cursor - old_cursor < total_length
            push!(subpackets, parse_packet(parser))
        end
    else
        num_packets = readint(parser, 11)
        for _ = 1:num_packets
            push!(subpackets, parse_packet(parser))
        end
    end

    return OperatorPacket(version, ptid, subpackets)
end

version_sum(packet::LiteralPacket) = packet.version
version_sum(packet::OperatorPacket) = packet.version + sum(version_sum, packet.subpackets)

functions = [+, *, min, max, Base.identity, >, <, ==]
eval(packet::LiteralPacket) = packet.value
eval(packet::OperatorPacket) = functions[packet.ptid+1](eval.(packet.subpackets)...)

open(ARGS[1]) do file
    input = read(file, String)
    bits = falses(4 * length(input))
    for (i, c) in enumerate(input)
        base16 = parse(Int, c, base = 16)
        for j = 4:-1:1
            bits[4*(i-1)+j] = base16 % 2
            base16 ÷= 2
        end
    end

    parser = Parser(bits, 1)
    packet = parse_packet(parser)
    println(version_sum(packet))
    println(eval(packet))
end