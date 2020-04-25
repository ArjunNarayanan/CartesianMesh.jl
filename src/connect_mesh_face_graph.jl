function element_face_start(elid::Int64,mesh::UniformMesh)
    @assert elid > 0
    return (elid-1)*mesh.faces_per_element+1
end

function element_face_stop(elid::Int64,mesh::UniformMesh)
    @assert elid > 0
    return elid*mesh.faces_per_element
end

function element_face_ids(elid::Int64,mesh::UniformMesh)
    return element_face_start(elid,mesh):element_face_stop(elid,mesh)
end

function element_face_ids(ely::Int64,elx::Int64,mesh::UniformMesh)
    elid = get_element_idx(ely,elx,mesh)
    return element_face_ids(elid,mesh)
end

function element_face_id(ely::Int64,elx::Int64,faceid::Int64,
    mesh::UniformMesh{2})

    elid = get_element_idx(ely,elx,mesh)
    return element_face_id(elid,faceid,mesh)
end

function element_face_id(elid::Int64,faceid::Int64,mesh::UniformMesh)

    @assert elid <= mesh.total_number_of_elements
    @assert 1 <= faceid <= mesh.faces_per_element

    return element_face_start(elid,mesh) + faceid - 1
end

function on_bottom_boundary(ely,elx,mesh::UniformMesh{2})
    if ely == 1
        return true
    else
        return false
    end
end

function on_left_boundary(ely,elx,mesh::UniformMesh{2})
    if elx == 1
        return true
    else
        return false
    end
end

function on_top_boundary(ely,elx,mesh::UniformMesh{2})
    if ely == mesh.nelements[2]
        return true
    else
        return false
    end
end

function on_right_boundary(ely,elx,mesh::UniformMesh{2})
    if elx == mesh.nelements[1]
        return true
    else
        return false
    end
end

function connect_element_faces!(ely,elx,mesh::UniformMesh{2},
    bdry_node,g::SimpleGraph)

    faceids = element_face_ids(ely,elx,mesh)
    if on_bottom_boundary(ely,elx,mesh)
        add_edge!(g,faceids[1],bdry_node)
    else
        nbr = element_face_id(ely-1,elx,3,mesh)
        add_edge!(g,faceids[1],nbr)
    end

    if on_right_boundary(ely,elx,mesh)
        add_edge!(g,faceids[2],bdry_node)
    else
        nbr = element_face_id(ely,elx+1,4,mesh)
        add_edge!(g,faceids[2],nbr)
    end

    if on_top_boundary(ely,elx,mesh)
        add_edge!(g,faceids[3],bdry_node)
    else
        nbr = element_face_id(ely+1,elx,1,mesh)
        add_edge!(g,faceids[3],nbr)
    end

    if on_left_boundary(ely,elx,mesh)
        add_edge!(g,faceids[4],bdry_node)
    else
        nbr = element_face_id(ely,elx-1,2,mesh)
        add_edge!(g,faceids[4],nbr)
    end
end
function get_element_idx(ely,elx,mesh::UniformMesh{2})
    return (elx-1)*mesh.nelements[2]+ely
end

function face_connectivity_graph(mesh::UniformMesh{2})
    num_vertices = mesh.total_number_of_elements*mesh.faces_per_element + 1
    g = SimpleGraph(num_vertices)

    elid = 1
    for elx in 1:mesh.nelements[1]
        for ely in 1:mesh.nelements[2]
            connect_element_faces!(ely,elx,mesh,num_vertices,g)
        end
    end
    return g,num_vertices
end
