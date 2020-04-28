function element_face_start(elid,faces_per_element)
    @assert elid > 0
    return (elid-1)*faces_per_element+1
end

function element_face_stop(elid,faces_per_element)
    @assert elid > 0
    return elid*faces_per_element
end

function element_face_ids(elid,faces_per_element)
    return element_face_start(elid,faces_per_element):element_face_stop(elid,faces_per_element)
end

function element_face_ids(ely,elx,nelements,faces_per_element)
    elid = get_element_idx(ely,elx,nelements)
    return element_face_ids(elid,faces_per_element)
end

function element_face_id(elid,faceid,faces_per_element)

    @assert 1 <= faceid <= faces_per_element
    return element_face_start(elid,faces_per_element) + faceid - 1
end

function get_element_idx(ely,elx,nelements::SVector{2})
    return (elx-1)*nelements[2]+ely
end

function element_face_id(ely,elx,faceid,nelements::SVector{2},faces_per_element)

    elid = get_element_idx(ely,elx,nelements)
    return element_face_id(elid,faceid,faces_per_element)
end

function on_bottom_boundary(ely,elx,nelements::SVector{2})
    if ely == 1
        return true
    else
        return false
    end
end

function on_left_boundary(ely,elx,nelements::SVector{2})
    if elx == 1
        return true
    else
        return false
    end
end

function on_top_boundary(ely,elx,nelements::SVector{2})
    if ely == nelements[2]
        return true
    else
        return false
    end
end

function on_right_boundary(ely,elx,nelements::SVector{2})
    if elx == nelements[1]
        return true
    else
        return false
    end
end

function connect_element_faces!(ely,elx,nelements::SVector{2},
    faces_per_element,g::SimpleGraph,bdry_node)

    faceids = element_face_ids(ely,elx,nelements,faces_per_element)

    if on_bottom_boundary(ely,elx,nelements)
        add_edge!(g,faceids[1],bdry_node)
    else
        nbr_faceid = 3
        nbr = element_face_id(ely-1,elx,nbr_faceid,nelements,faces_per_element)
        add_edge!(g,faceids[1],nbr)
    end

    if on_right_boundary(ely,elx,nelements)
        add_edge!(g,faceids[2],bdry_node)
    else
        nbr_faceid = 4
        nbr = element_face_id(ely,elx+1,nbr_faceid,nelements,faces_per_element)
        add_edge!(g,faceids[2],nbr)
    end

    if on_top_boundary(ely,elx,nelements)
        add_edge!(g,faceids[3],bdry_node)
    else
        nbr_faceid = 1
        nbr = element_face_id(ely+1,elx,nbr_faceid,nelements,faces_per_element)
        add_edge!(g,faceids[3],nbr)
    end

    if on_left_boundary(ely,elx,nelements)
        add_edge!(g,faceids[4],bdry_node)
    else
        nbr_faceid = 2
        nbr = element_face_id(ely,elx-1,nbr_faceid,nelements,faces_per_element)
        add_edge!(g,faceids[4],nbr)
    end
end

function face_connectivity_graph(nelements::SVector{2},
    total_number_of_elements,faces_per_element)

    num_vertices = total_number_of_elements*faces_per_element + 1
    g = SimpleGraph(num_vertices)

    for elx in 1:nelements[1]
        for ely in 1:nelements[2]
            connect_element_faces!(ely,elx,nelements,faces_per_element,g,num_vertices)
        end
    end
    return g,num_vertices
end

function global_faceid_to_local_faceid(faceid::Int64,faces_per_element::Int64)
    return (faceid-1)%faces_per_element+1
end

function global_faceid_to_elemid(faceid::Int64,faces_per_element::Int64)
    return ceil(Int,faceid/faces_per_element)
end

function update_el2hybrid!(el2hybrid,idx,faceid,faces_per_element)
    elemid = global_faceid_to_elemid(faceid,faces_per_element)
    local_faceid = global_faceid_to_local_faceid(faceid,faces_per_element)
    el2hybrid[local_faceid,elemid] = idx
end

function get_face_to_hybrid_element_number(g,total_number_of_elements,
    faces_per_element)

    bdrynode = nv(g)
    el2hybrid = zeros(Int,faces_per_element,total_number_of_elements)
    edgeiterator = edges(g)

    for (idx,e) in enumerate(edgeiterator)
        if e.src == bdrynode || e.dst == bdrynode
            faceid = e.src == bdrynode ? e.dst : e.src
            update_el2hybrid!(el2hybrid,idx,faceid,faces_per_element)
        else
            update_el2hybrid!(el2hybrid,idx,e.src,faces_per_element)
            update_el2hybrid!(el2hybrid,idx,e.dst,faces_per_element)
        end
    end

    return el2hybrid
end

function update_face_indicator!(face_indicator,indicator::Symbol,faceid,faces_per_element)
    elemid = global_faceid_to_elemid(faceid,faces_per_element)
    local_faceid = global_faceid_to_local_faceid(faceid,faces_per_element)
    face_indicator[local_faceid,elemid] = indicator
end

function get_face_indicator(g,total_number_of_elements,faces_per_element)

    bdrynode = nv(g)
    face_indicator = Array{Symbol,2}(undef,faces_per_element,total_number_of_elements)

    for e in edges(g)
        if e.src == bdrynode || e.dst == bdrynode
            faceid = e.src == bdrynode ? e.dst : e.src
            update_face_indicator!(face_indicator,:boundary,faceid,faces_per_element)
        else
            update_face_indicator!(face_indicator,:interior,e.src,faces_per_element)
            update_face_indicator!(face_indicator,:interior,e.dst,faces_per_element)
        end
    end
    return face_indicator
end
