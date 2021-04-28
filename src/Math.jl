module Math

using Plots

import Base: 
    +,
    -,
    *,
    /,
    ^,
    sin,
    cos,
    tan,
    exp,
    convert,
    promote_rule,
    real

struct Dual <: Number
    y::Number
    dy::Number
end

Dual(x::Number) = Dual(x, zero(x))

+(f::Dual, g::Dual) = Dual(f.y + g.y, f.dy + g.dy)
-(f::Dual, g::Dual) = Dual(f.y - g.y, f.dy - g.dy)
*(f::Dual, g::Dual) = Dual(f.y * g.y, f.dy * g.y + f.y * g.dy)
/(f::Dual, g::Dual) = Dual(f.y / g.y, (f.dy * g.y - f.y * g.dy) / (g.y ^ 2))
^(f::Dual, g::Dual) = Dual(f.y ^ g.y, f.y ^ g.y * (g.dy * log(f.y) + f.dy * g.y / f.y))
sin(theta::Dual) = Dual(sin(theta.y), theta.dy * cos(theta.y))
cos(theta::Dual) = Dual(cos(theta.y), theta.dy * -sin(theta.y))
tan(theta::Dual) = Dual(tan(theta.y), theta.dy * sec(theta.y) ^ 2)
exp(x::Dual) = Dual(exp(x.y), x.dy * exp(x.y))

convert(::Type{Dual}, x::Type{<:Real}) = Dual(x, zero(x))
promote_rule(::Type{Dual}, ::Type{<:Number}) = Dual

real(::Type{Dual}) = Real

h(x) = cos(sin(pi * x)) + exp(x)

x = Array{Float64}(-10:0.01:10)
y = map(_x -> h(Dual(_x, 1)).y, x)
dy = map(_x -> h(Dual(_x, 1)).dy, x)

plot(x, y)
display(plot!(x, dy))

end
