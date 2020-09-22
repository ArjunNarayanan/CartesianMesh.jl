function dimension(mesh::UniformMesh{dim}) where dim
    return dim
end

function number_of_elements(mesh)
    return mesh.total_number_of_elements
end

function linear_to_cartesian_index(mesh::UniformMesh{2},idx::Z) where {Z<:Integer}

    1 <= idx <= mesh.total_number_of_elements || throw(BoundsError(mesh,idx))
    elx = ceil(Int,idx/mesh.nelements[2])
    ely = idx - (elx-1)*mesh.nelements[2]
    return elx,ely

end

function element(mesh::UniformMesh{2},idx)

    elx,ely = linear_to_cartesian_index(mesh,idx)
    xL = mesh.x0 + [(elx-1)*mesh.element_size[1],(ely-1)*mesh.element_size[2]]
    xR = mesh.x0 + [(elx)*mesh.element_size[1],(ely)*mesh.element_size[2]]
    return xL,xR

end

function neighbors(mesh::UniformMesh{2},idx)

    elx,ely = linear_to_cartesian_index(mesh,idx)
    bdryflag = mesh.bdryflag

    bottom = ely == 1 ? bdryflag : idx-1
    right = elx == mesh.nelements[1] ? bdryflag : idx+mesh.nelements[2]
    top = ely == mesh.nelements[2] ? bdryflag : idx+1
    left = elx == 1 ? bdryflag : idx-mesh.nelements[2]

    return [bottom,right,top,left]

end

function faces_per_cell(mesh::UniformMesh{2})
    return 4
end
