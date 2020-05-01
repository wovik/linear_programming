using JuMP
using GLPK

using LinearAlgebra

function programs(time, memory, functions, maxMemory)

    model = Model(GLPK.Optimizer)

    (m, n) = size(time)

    @variable(model, choice[1:m, 1:n], Bin)

    @objective(model, Min, dot(choice, time))

    for i in 1:m
        if i in functions
            @constraint(model, sum(choice[i, 1:n]) == 1)
        else
            @constraint(model, sum(choice[i, 1:n]) == 0)
        end
    end

    @constraint(model, dot(choice, memory) <= maxMemory)

    optimize!(model)
    status = termination_status(model)
    if status == MOI.OPTIMAL
        return (termination_status(model), objective_value(model), value.(choice))
    else
        return (status, nothing, nothing)
    end
end

time = [1 1 1 1 2;
        2 5 3 2 1;
        3 9 1 1 2;
        3 4 6 5 8;
        3 3 3 3 3;
        6 6 7 6 9]

memo = [9 9 8 9 7;
        3 1 5 8 7;
        5 1 8 7 8;
        4 4 4 3 1;
        7 7 9 6 8;
        2 1 2 3 1]
functions = [1, 2, 3, 4, 5, 6]
maxMemory = 17

(status, time, choice) = programs(time, memo, functions, maxMemory)

if status == MOI.INFEASIBLE
    println("No feasible solutions")
else
    (m, n) = size(choice)
    println("time needed: ", time)
    println("needed memory: ", dot(choice, memo))
    for i in 1:m
        for j in 1:n
            if choice[i,j] == 1
                println("For function ", i, " program from library ", j, " was used")
            end
        end
    end
end
