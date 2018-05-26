__precompile__()

module Sellmeier

const codefile = joinpath(dirname(@__FILE__), "literate_org_tangled_code.jl")
if isfile(codefile)
    include(codefile)
else
    error("Sellmeier not properly installed. Please run Pkg.build(\"Sellmeier\") then restart Julia.")
end

end
