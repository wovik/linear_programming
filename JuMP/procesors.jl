using JuMP
using GLPK

function procesors(time)
    model = Model(GLPK.Optimizer)

    (m,n) = size(time)

    big = sum(time)

    @variable(model, start[1:m, 1:n] >=0, Int)
    @variable(model, ms, Int)
    @variable(model, y[1:m, 1:m, 1:n], Bin)
    @variable(model, x[1:m, 1:m, 1:n], Bin)

    @objective(model, Min, ms)

    for i in 1:m
        for j in 1:(n-1)
            @constraint(model, start[i,j]+time[i,j] <= start[i,j+1])
        end
    end

    for i in 1:m
        @constraint(model, start[i,n]+time[i,n] <= ms)
    end

    for j in 1:n
        for (i,k) in [(i,k) for i=1:m, k=1:m if i<k]
            @constraint(model, start[i,j]-start[k,j]+y[i,k,j]*big >= time[k,j])
            @constraint(model, start[k,j]-start[i,j]+(1-y[i,k,j])*big >= time[i,j])
        end
    end

    for (i,k) in [(i,k) for i=1:m, k=1:m if i<k]
        for j in 1:(n-1)
            @constraint(model, start[i,j]   - start[k,j] +   x[i,k,j]*big >= 0 )
            @constraint(model, start[i,j+1] - start[k,j+1] + x[i,k,j]*big >= 0 )
            @constraint(model, start[k,j]   - start[i,j] +   (1-x[i,k,j])*big >= 0 )
            @constraint(model, start[k,j+1] - start[i,j+1] + (1-x[i,k,j])*big >= 0 )
        end
    end

    optimize!(model)
    status = termination_status(model)
    if status == MOI.OPTIMAL
        return (termination_status(model), objective_value(model), value.(start))
    else
        return (status, nothing, nothing)
    end

end


function printGrannt(endTime, startTimes, duration)
    (m, n) = size(startTimes)

    machines = 1:n
    tasks = 1:m

    colors = [:red :blue :green :yellow :cyan :purple :magenta :light_blue :light_cyan :light_green :light_magenta :light_red]

    for j in machines
        print(j, ": ")
        for t in 0:endTime
            found = false
            for i in tasks
                if startTimes[i,j] <= t && startTimes[i,j]+duration[i,j] > t
                    found = true
                    printstyled(i, color=colors[i])
                end
            end
            if !found
                print('_')
            end
        end
        print("\n")
    end
end

# params

time = [1 2 1;
        5 6 4;
        1 4 4;
        3 4 4;
        6 7 4;
        3 7 3]

# printGrannt(9, [2 4 5], [1 3 4])

(status, endTime, startTime) = procesors(time)

if status == MOI.OPTIMAL
    printGrannt(endTime, startTime, time)
    println("time needed: ", endTime)
else
    println("Solution infeasible")
end
