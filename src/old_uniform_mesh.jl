struct UniformMesh{dim,T,Z}
    x0::SVector{dim,T}
    widths::SVector{dim,T}
    nelements::SVector{dim,Z}
    element_size::SVector{dim,T}
    total_number_of_elements::Z
    total_number_of_faces::Z
    faces_per_element::Z
    face_to_hybrid_element_number::Matrix{Z}
    face_indicator::Matrix{Symbol}
    total_number_of_hybrid_elements::Z
    function UniformMesh(x0::SVector{dim,T},widths::SVector{dim,T},
        nelements::SVector{dim,Z}) where {dim,T,Z<:Integer}

        @assert all(nelements .> 0)
        @assert all(widths .> 0.0)

        element_size = widths ./ nelements
        total_number_of_elements = prod(nelements)
        faces_per_element = get_number_of_element_faces(dim)

        total_number_of_faces = faces_per_element*total_number_of_elements

        g,bdrynode = face_connectivity_graph(nelements,total_number_of_elements,
            faces_per_element)
        total_number_of_hybrid_elements = ne(g)
        face_to_hybrid_element_number = get_face_to_hybrid_element_number(g,total_number_of_elements,
            faces_per_element)
        face_indicator = get_face_indicator(g,total_number_of_elements,
            faces_per_element)

        new{dim,T,Z}(x0,widths,nelements,element_size,
            total_number_of_elements,total_number_of_faces,faces_per_element,
            face_to_hybrid_element_number,face_indicator,total_number_of_hybrid_elements)
    end
end

function UniformMesh(x0::Vector{T},widths::Vector{T},
    nelements::Vector{Z}) where {T<:Real,Z<:Integer}

    dim = length(x0)
    @assert length(widths) == dim
    @assert length(nelements) == dim

    sx0 = SVector{dim,T}(x0)
    swidths = SVector{dim,T}(widths)
    snelements = SVector{dim,Z}(nelements)
    UniformMesh(sx0,swidths,snelements)
end

function get_number_of_element_faces(dim)
    if dim == 2
        return 4
    elseif dim == 3
        return 6
    else
        throw(ArgumentError("Expected `dim ∈ {2,3}`, got `dim = $dim`"))
    end
end
