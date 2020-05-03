# Wojciech Kowalik

using JuMP
using GLPK

using LinearAlgebra


function resources(limit, time, need, precedence)
    model = Model(GLPK.Optimizer)

    p = size(time, 1)
    (res, n) = size(need)

    maxTime = sum(time)

    @variable(model, start[1:n] >=1, Int)
    @variable(model, ms, Int)
    @variable(model, x[1:n, 1:maxTime], Bin)
    @variable(model, y[1:n, 1:maxTime], Bin)
    @variable(model, z[1:n, 1:maxTime], Bin)

    @objective(model, Min, ms)

    for i in 1:n
        @constraint(model, start[i]+t[i] <= ms)
    end

    for (i,j) in [(i,j) for i=1:n, j=1:n if i != j]
        if i in precedence[j]
            @constraint(model, start[j] >= start[i]+time[i])
        end
    end

    for t in 1:maxTime
        for i in 1:n
            @constraint(model, start[i] - t + x[i,t]*maxTime >= 0)
            @constraint(model, start[i]+time[i] - t - y[i,t]*maxTime <= -1)
            @constraint(model, y[i,t] + x[i,t] - z[i,t] <= 1)
        end
    end

    for t in 1:maxTime
        for i in 1:res
            @constraint(model, dot(z[1:n,t], need[i, 1:n]) <= limit[i])
        end
    end

    optimize!(model)
    status = termination_status(model)

    if status == MOI.OPTIMAL
        return (termination_status(model), objective_value(model), value.(start), value.(x), value.(y), value.(z))
    else
        return (status, nothing, nothing, nothing, nothing, nothing)
    end
end

function printGrannt(start, time, need, endTime)
    (res, n) = size(need)
    d = Dict()
    for t in 1:endTime
        ev = []
        now = []
        changed = false
        for i in 1:n
            if start[i] == t
                push!(ev, i)
            elseif start[i]+time[i] == t
                changed = true
            elseif start[i] < t < start[i]+time[i]
                push!(now, i)
            end
        end
        if size(ev, 1) != 0 || changed
            d[t] = vcat(ev, now)
        end
    end

    (max,) = maximum(size, values(d))
    max = max + 1


    strings = repeat(["\t"], max+res)
    strings[1] = "t\t"
    for i in 1:res
        strings[max+i] = string('R', i, '\t')
    end

    for t in sort(collect(keys(d)))
        ev = sort(d[t])
        strings[1] = strings[1] * string(Int(t), '\t')
        for i in 2:max
            if size(ev, 1) >= i-1
                strings[i] = strings[i] * string(ev[i-1], '\t')
            else
                strings[i] = strings[i] * string('_', '\t')
            end
        end
        for i in 1:res
            sum = 0
            for e in ev
                sum += need[i, e]
            end
            strings[max+i] = strings[max+i] * string(sum, '\t')
        end
    end
    for s in strings
        println(s)
    end
end


# params

N = [30]

need = [ 9 17 11  4 13  7  7 17]
time = [50 47 55 46 32 57 15 62]

p = []
push!(p, [])
push!(p, [1])
push!(p, [1])
push!(p, [1])
push!(p, [2])
push!(p, [3 4])
push!(p, [4])
push!(p, [5 6 7])

(status, endTime, startTime, x, y, z) = resources(N, time, need, p)

if status == MOI.OPTIMAL
    printGrannt(startTime, time, need, endTime)
    println("time needed: ", endTime)
else
    println("Solution infeasible")
end
