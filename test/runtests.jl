using SafeTestsets

@safetestset "Test Uniform Mesh Construction" begin
    include("test_uniform_mesh.jl")
end

@safetestset "Test Mesh Attributes" begin
    include("test_mesh_attributes.jl")
end
