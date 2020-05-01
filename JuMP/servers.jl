using JuMP
using GLPK

using LinearAlgebra

function serversAccess(time, availability)

    model = Model(GLPK.Optimizer)

    (m, n) = size(availability)
    @variable(model, x[1:m], Bin)

    @objective(model, Min, dot(time, x))

    for i in 1:n
        @constraint(model, dot(x, availability[1:m, i]) >= 1)
    end

    optimize!(model)
    status = termination_status(model)
    if status == MOI.OPTIMAL
        return (termination_status(model), objective_value(model), value.(x))
    else
        return (status, nothing, nothing)
    end

end



# param

# n - liczba cech
# m - liczba serwerów

n = 6
time = [2, 4, 5, 1, 2, 3, 6, 25]
m = size(time, 1)

availability = falses(m, n)
availability[1,1] = 1
availability[1,6] = 1
availability[2,2] = 1
availability[3,3] = 1
availability[3,5] = 1
availability[3,6] = 1
availability[4,3] = 1
availability[5,1] = 1
availability[5,4] = 1
availability[6,5] = 1
availability[7,2] = 1
availability[7,3] = 1
availability[7,6] = 1
availability[8,1] = 1
availability[8,2] = 1
availability[8,3] = 1
availability[8,4] = 1
availability[8,5] = 1
availability[8,6] = 1
serversAccess(time, availability)
