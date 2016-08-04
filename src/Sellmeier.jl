module Sellmeier

using Calculus

type Medium
    B::Vector
    C::Vector
end

import Base.writemime
function writemime(io::IO, ::MIME"text/latex", m::Medium)
    print(io, "\$\$")
    print(io, "n^2 - 1 =")
    print(io, join(["\\frac{$(m.B[i])\\lambda^2}{\\lambda^2 - $(m.C[i])~\\mathrm{\\mu m^2}}" for i = 1:length(m.B)], "+"))
    print(io, "\$\$")
end

BK7 = Medium([1.03961212, 0.231792344, 1.01046945],
             [6.00069867e-3, 2.00179144e-2, 1.03560653e2])
SiO2 = Medium([0.6961663, 0.4079426, 0.8974794],
              [0.0684043, 0.1162414, 9.896161].^2)

function n2(m::Medium, lambda::Float64)
    if !isfinite(lambda)
        1.0
    else
        1.0 + reduce(+, 0,
                     [m.B[i]*(lambda*1e6).^2./((lambda*1e6).^2-m.C[i])
                      for i = eachindex(m.B)])
    end
end
n2(m::Medium, lambda::Vector{Float64}) =
    Vector{Float64}([n2(m, l) for l in lambda])

maybe_complex(n) = any(n.<0) ? complex(n) : n
n(m::Medium, lambda) = sqrt(maybe_complex(n2(m, lambda)))
n_f(m::Medium, freq) = n(m, 299792458./freq)

# Calculate dispersion through a medium of length d (in meters, may be
# negative). Optionally, remove central frequency k-vector, to keep
# pulse centered.
function dispersion(m::Medium, d::Float64,
                    freq, freq0 = 0)
    n = real(n_f(m, freq))

    k0 = 2pi*freq/299792458
    k = n.*k0

    if freq0 != 0
        # Slope of dispersion relation at central frequency
        dkdf = 2pi/299792458*derivative(f -> real(n_f(m, f))*f, freq0)
        k -= dkdf.*freq
    end

    exp(im*k*d)
end

export Medium, BK7, SiO2, n2, n, n_f, dispersion

end
