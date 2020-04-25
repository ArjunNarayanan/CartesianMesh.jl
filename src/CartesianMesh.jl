module CartesianMesh

using StaticArrays, LightGraphs

include("uniform_mesh.jl")
include("connect_mesh_face_graph.jl")

export UniformMesh

end # module
