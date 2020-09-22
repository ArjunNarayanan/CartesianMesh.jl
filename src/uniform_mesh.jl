struct UniformMesh{dim}
    x0
    widths
    nelements
    element_size
    total_number_of_elements
    bdryflag
    function UniformMesh(x0,widths,nelements)

        @assert all(nelements .> 0)
        @assert all(widths .> 0)

        dim = length(x0)
        @assert length(widths) == dim
        @assert length(nelements) == dim

        element_size = widths ./ nelements
        total_number_of_elements = prod(nelements)
        bdryflag = 0

        new{dim}(x0,widths,nelements,element_size,
            total_number_of_elements,bdryflag)

    end
end
