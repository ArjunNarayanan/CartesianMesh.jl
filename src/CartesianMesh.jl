module CartesianMesh

using StaticArrays

include("uniform_mesh.jl")
include("mesh_attributes.jl")

export UniformMesh, faces_per_cell, neighbors, element, number_of_elements

end # module
