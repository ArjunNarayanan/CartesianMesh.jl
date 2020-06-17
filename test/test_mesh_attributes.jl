using Test
using StaticArrays
# using Revise
using CartesianMesh

CM = CartesianMesh

function allequal(v1,v2)
    return all(v1 .≈ v2)
end

x0 = [5.,8.]
widths = [2.,3.]
nelements = [5,3]
mesh = CM.UniformMesh(x0,widths,nelements)

@test_throws BoundsError CM.linear_to_cartesian_index(mesh,0)
@test_throws BoundsError CM.linear_to_cartesian_index(mesh,16)

elx,ely = CM.linear_to_cartesian_index(mesh,8)
@test (elx,ely) == (3,2)
@test CM.linear_to_cartesian_index(mesh,6) == (2,3)
@test CM.linear_to_cartesian_index(mesh,1) == (1,1)
@test CM.linear_to_cartesian_index(mesh,15) == (5,3)

mesh = CM.UniformMesh(x0,widths,[1,1])
@test CM.linear_to_cartesian_index(mesh,1) == (1,1)

xL,xR = CM.element(mesh,1)
@test allequal(xL,[5.,8.])
@test allequal(xR,[7.,11.])

mesh = CM.UniformMesh(x0,widths,[5,3])
xL,xR = CM.element(mesh,9)
@test allequal(xL,[5.8,10.])
@test allequal(xR,[6.2,11.])

nbrs = CM.neighbors(mesh,1)
@test allequal(nbrs,[mesh.bdryflag,4,2,mesh.bdryflag])
nbrs = CM.neighbors(mesh,5)
@test allequal(nbrs,[4,8,6,2])
nbrs = CM.neighbors(mesh,3)
@test allequal(nbrs,[2,6,mesh.bdryflag,mesh.bdryflag])

@test CM.faces_per_cell(mesh) == 4
