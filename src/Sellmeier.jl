module Sellmeier

type Medium
    B::Vector
    C::Vector
end

import Base.writemime
function writemime(io::IO, ::MIME"text/latex", m::Medium)
    print(io, "\$\$")
    print(io, "n^2 - 1 =")
    print(io, join(["\\frac{$(m.B[i])\\lambda^2}{\\lambda^2 - $(m.C[i])}" for i = 1:length(m.B)], "+"))
    print(io, "\$\$")
end

BK7 = Medium([1.03961212, 0.231792344, 1.01046945],
             [6.00069867e-3, 2.00179144e-2, 1.03560653e2])
SiO2 = Medium([0.6961663, 0.4079426, 0.8974794],
              [0.0684043, 0.1162414, 9.896161].^2)

n2(m::Medium, lambda) = 1.0 + reduce(+, zeros(lambda),
                                     [m.B[i]*(lambda*1e6).^2./((lambda*1e6).^2-m.C[i])
                                      for i = eachindex(m.B)])
n(m::Medium, lambda) = sqrt(n2(m, lambda))

export Medium, BK7, SiO2, n2, n

end
