using Sellmeier
using Base.Test

const testfile = joinpath(dirname(@__FILE__), "literate_org_tangled_tests.jl")
if isfile(testfile)
    include(testfile)
else
    error("Sellmeier not properly installed. Please run Pkg.build(\"Sellmeier\") then restart Julia.")
end
