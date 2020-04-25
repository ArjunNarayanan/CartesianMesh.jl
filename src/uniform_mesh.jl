struct UniformMesh{dim,T}
    x0::SVector{dim,T}
    widths::SVector{dim,T}
    nelements::SVector{dim,Int64}
    element_size::SVector{dim,T}
    total_number_of_elements::Int64
    faces_per_element::Int64
    function UniformMesh(x0::SVector{dim,T},widths::SVector{dim,T},
        nelements::SVector{dim,Int64}) where {dim,T}

        @assert all(nelements .> 0)
        @assert all(widths .> 0.0)

        element_size = widths ./ nelements
        total_number_of_elements = prod(nelements)
        faces_per_element = get_number_of_element_faces(dim)

        new{dim,T}(x0,widths,nelements,element_size,
            total_number_of_elements,faces_per_element)
    end
end

function UniformMesh(x0::Vector{T},widths::Vector{T},
    nelements::Vector{Int64}) where {T}

    dim = length(x0)
    @assert length(widths) == dim
    @assert length(nelements) == dim

    sx0 = SVector{dim,T}(x0)
    swidths = SVector{dim,T}(widths)
    snelements = SVector{dim,Int64}(nelements)
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
