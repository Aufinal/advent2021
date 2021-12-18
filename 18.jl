abstract type SnailFish end

mutable struct SnailFishNode <: SnailFish
    parent::Union{SnailFishNode,Nothing}
    left::SnailFish
    right::SnailFish

    function SnailFishNode(parent, left, right)
        res = new(parent, left, right)
        res.left.parent = res
        res.right.parent = res
        return res
    end
end

mutable struct SnailFishLeaf <: SnailFish
    parent::Union{SnailFishNode,Nothing}
    value::Int
end

SnailFishLeaf(value::Int) = SnailFishLeaf(nothing, value)
SnailFishNode(left, right) = SnailFishNode(nothing, left, right)

copy(node::SnailFishLeaf) = SnailFishLeaf(node.value)
copy(node::SnailFishNode) = SnailFishNode(copy(node.left), copy(node.right))

parse(value::Int, parent::Union{SnailFishNode,Nothing}) = SnailFishLeaf(parent, value)
parse(expr::Expr, parent::Union{SnailFishNode,Nothing}) =
    SnailFishNode(parent, parse(expr.args[1], nothing), parse(expr.args[2], nothing))
parse(expr::String) = parse(Meta.parse(expr), nothing)

function add_closest(node::SnailFishLeaf, direction::Symbol)
    found = false
    value = node.value
    revdir = direction == :left ? :right : :left
    while !found && !isnothing(node.parent)
        found = node != getfield(node.parent, direction)
        node = node.parent
    end
    found || return
    node = getfield(node, direction)
    while node isa SnailFishNode
        node = getfield(node, revdir)
    end
    node.value += value
end

explode!(node::SnailFish) = explode!(node, 0, :root)
explode!(node::SnailFishLeaf, depth::Int, side::Symbol) = false
function explode!(node::SnailFishNode, depth::Int, side::Symbol)::Bool
    if depth ≥ 4
        add_closest(node.left, :left)
        add_closest(node.right, :right)
        setfield!(node.parent, side, SnailFishLeaf(node.parent, 0))
        return true
    else
        return explode!(node.left, depth + 1, :left) || explode!(node.right, depth + 1, :right)
    end
end

split!(node::SnailFish) = split!(node, :root)
split!(node::SnailFishNode, side::Symbol) = split!(node.left, :left) || split!(node.right, :right)
function split!(node::SnailFishLeaf, side::Symbol)::Bool
    node.value < 10 && return false
    mid = node.value ÷ 2
    setfield!(
        node.parent,
        side,
        SnailFishNode(node.parent, SnailFishLeaf(mid), SnailFishLeaf(node.value - mid))
    )
    return true
end

function reduce!(node)
    while explode!(node) || split!(node)
    end
    return node
end

Base.:+(lhs::SnailFish, rhs::SnailFish) = reduce!(SnailFishNode(copy(lhs), copy(rhs)))
Base.:+(lhs::Nothing, rhs::SnailFish) = rhs

magnitude(node::SnailFishLeaf) = node.value
magnitude(node::SnailFishNode) = 3 * magnitude(node.left) + 2 * magnitude(node.right)

open(ARGS[1]) do file
    fishes = parse.(readlines(file))
    @time part1 = magnitude(reduce(+, fishes, init = nothing))
    println(part1)
    @time part2 = maximum(magnitude(fishes[i] + fishes[j]) for i = 1:length(fishes) for j in 1:length(fishes) if i != j)
    println(part2)
end