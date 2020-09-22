using Test
using CartesianMesh

CM = CartesianMesh

float_type = typeof(1.0)

function allequal(v1,v2)
    return all(v1 .≈ v2)
end

x0 = [1.0,2.0]
widths =  [-1.,2.]
nelements =  [5,-6]
@test_throws AssertionError CM.UniformMesh(x0,widths,nelements)
widths =  [4.,5.]
@test_throws AssertionError CM.UniformMesh(x0,widths,nelements)

widths =  [3.,4.]
nelements =  [3,4]

mesh = CM.UniformMesh(x0,widths,nelements)
@test allequal(mesh.x0,x0)
@test allequal(mesh.widths,widths)
@test allequal(mesh.nelements,nelements)
@test mesh.total_number_of_elements == 12
@test mesh.bdryflag == 0

element_size = [1.,1.]
@test allequal(mesh.element_size,element_size)

x0 = [2.,3.]
widths = [3.0,5.0,6.]
nelements = [1,2,3]
@test_throws AssertionError CM.UniformMesh(x0,widths,nelements)
widths = [3.,5.]
@test_throws AssertionError CM.UniformMesh(x0,widths,nelements)

nelements = [5,6]
mesh = CM.UniformMesh(x0,widths,nelements)
@test allequal(mesh.x0,x0)
@test allequal(mesh.widths,widths)
@test allequal(mesh.nelements,nelements)
@test mesh.total_number_of_elements == 30
@test mesh.bdryflag == 0
element_size = [3.0/5,5.0/6]
@test allequal(mesh.element_size,element_size)
