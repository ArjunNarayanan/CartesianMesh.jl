struct UniformMesh{dim,T}
    x0::SVector{dim,T}
    widths::SVector{dim,T}
    nelements::SVector{dim,Int}
    element_size::SVector{dim,T}
    total_number_of_elements::Int
    bdryflag::Int
    function UniformMesh(x0::SVector{dim,T},widths::SVector{dim,T},
        nelements::SVector{dim,Int}) where {dim,T<:AbstractFloat}

        @assert all(nelements .> 0)
        @assert all(widths .> 0)

        element_size = widths ./ nelements
        total_number_of_elements = prod(nelements)
        bdryflag = total_number_of_elements+1

        new{dim,T}(x0,widths,nelements,element_size,total_number_of_elements,bdryflag)

    end
end

function UniformMesh(x0,widths,nelements)

    dim = length(x0)
    @assert length(widths) == dim
    @assert length(nelements) == dim

    sx0 = SVector{dim}(x0)
    swidths = SVector{dim}(widths)
    snelements = SVector{dim}(nelements)
    return UniformMesh(sx0,swidths,snelements)

end
