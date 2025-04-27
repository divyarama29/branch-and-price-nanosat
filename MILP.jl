using JuMP
using Gurobi

# Function to solve MILP for a single instance
function solve_milp_nanosatellite(params)
    # Extract parameters
    J = params[:J]
    T = params[:T]
    r_t = params[:r_t]
    u_j = params[:u_j]
    q_j = params[:q_j]
    min_statup_j = params[:min_statup_j]
    max_statup_j = params[:max_statup_j]
    min_cpu_time_j = params[:min_cpu_time_j]
    max_cpu_time_j = params[:max_cpu_time_j]
    min_periodo_job_j = params[:min_periodo_job_j]
    max_periodo_job_j = params[:max_periodo_job_j]
    win_min_j = params[:win_min_j]
    win_max_j = params[:win_max_j]
    V_b = params[:V_b]
    γ = params[:γ]
    Q = params[:Q]
    e = params[:e]
    ρ = params[:ρ]
    ΔSoC = params[:ΔSoC]
    SoC_1 = params[:SoC_1]

    # MILP Model
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "OutputFlag", 1)

    # Variables
    @variable(model, x[j in J, t in T], Bin)  # Task j active at time t
    @variable(model, φ[j in J, t in T], Bin)  # Task j starts at time t
    @variable(model, 0 <= α[t in T] <= 1)     # Battery discharge fraction
    @variable(model, b[t in T])               # Battery power
    @variable(model, i[t in T])               # Battery current
    @variable(model, ρ <= SoC[t in T] <= 1)   # State of Charge

    # Objective: Maximize sum of task priorities
    @objective(model, Max, sum(u_j[j] * x[j, t] for j in J, t in T))

    # Constraints
    # Initial SoC
    @constraint(model, SoC[1] == SoC_1)

    # Power limit
    @constraint(model, power_limit[t in T],
        sum(q_j[j] * x[j, t] for j in J) + γ * V_b * α[t] <= r_t[t] + γ * V_b)

    # Power balance
    @constraint(model, power_balance[t in T],
        b[t] == r_t[t] - sum(q_j[j] * x[j, t] for j in J))

    # Battery current
    @constraint(model, battery_current[t in T], i[t] == b[t] / V_b)

    # SoC update
    @constraint(model, soc_update[t in T[1:end-1]],
        SoC[t+1] == SoC[t] + i[t] * e / (60 * Q))

    # Final SoC constraints
    @constraint(model, soc_upper, SoC[T[end]] <= SoC_1 * (1 + ΔSoC))
    @constraint(model, soc_lower, SoC[T[end]] >= SoC_1 * (1 - ΔSoC))

    # Startup constraints
    @constraint(model, startup_init[j in J], φ[j, T[1]] >= x[j, T[1]])
    @constraint(model, startup_diff[j in J, t in T[2:end]],
        φ[j, t] >= x[j, t] - x[j, t-1])
    @constraint(model, startup_upper1[j in J, t in T], φ[j, t] <= x[j, t])
    @constraint(model, startup_upper2[j in J, t in T[2:end]],
        φ[j, t] <= 2 - x[j, t] - x[j, t-1])

    # Minimum and maximum startups
    @constraint(model, min_startups[j in J], sum(φ[j, t] for t in T) >= min_statup_j[j])
    @constraint(model, max_startups[j in J], sum(φ[j, t] for t in T) <= max_statup_j[j])

    # Minimum CPU time
    @constraint(model, min_cpu[j in J, t in 1:(T[end] - min_cpu_time_j[j] + 1)],
        sum(x[j, l] for l in t:(t + min_cpu_time_j[j] - 1)) >= min_cpu_time_j[j] * φ[j, t])

    # Maximum CPU time
    @constraint(model, max_cpu[j in J, t in 1:(T[end] - max_cpu_time_j[j])],
        sum(x[j, l] for l in t:(t + max_cpu_time_j[j] - 1)) <= max_cpu_time_j[j])

    # Minimum CPU time at orbit end
    @constraint(model, min_cpu_end[j in J, t in (T[end] - min_cpu_time_j[j] + 2):T[end]],
        sum(x[j, l] for l in t:T[end]) >= (T[end] - t + 1) * φ[j, t])

    # Minimum period between startups
    @constraint(model, min_period[j in J, t in (1 + win_min_j[j]):(win_max_j[j] - min_periodo_job_j[j])],
        sum(φ[j, l] for l in t:(t + min_periodo_job_j[j] - 1)) <= 1)

    # Maximum period between startups
    @constraint(model, max_period[j in J, t in (1 + win_min_j[j]):(win_max_j[j] - max_periodo_job_j[j])],
        sum(φ[j, l] for l in t:(t + max_periodo_job_j[j] - 1)) >= 1)

    # Execution window constraints
    @constraint(model, win_min_con[j in J, t in 1:win_min_j[j]], x[j, t] == 0)
    @constraint(model, win_max_con[j in J, t in win_max_j[j]:T[end]], x[j, t] == 0)

    # Optimize
    optimize!(model)

    # Process results
    result = Dict()
    result[:instance_name] = get(params, :instance_name, "Unnamed")
    if termination_status(model) == MOI.OPTIMAL
        result[:status] = "Optimal"
        result[:objective] = objective_value(model)
        result[:x] = value.(x)
        result[:SoC] = value.(SoC)
        result[:solve_time] = solve_time(model)
        println("Instance: $(result[:instance_name])")
        println("MILP Status: Optimal")
        println("Objective Value: ", result[:objective])
        println("Solve Time: ", result[:solve_time], " seconds")
        println("Final SoC: ", result[:SoC][T[end]])
    else
        result[:status] = string(termination_status(model))
        result[:objective] = nothing
        result[:x] = nothing
        result[:SoC] = nothing
        result[:solve_time] = solve_time(model)
        println("Instance: $(result[:instance_name])")
        println("MILP Status: ", result[:status])
        println("Solve Time: ", result[:solve_time], " seconds")
    end
    return result
end

# Function to process multiple instances
function solve_multiple_instances(instances)
    results = []
    for (idx, params) in enumerate(instances)
        println("\nSolving instance $idx: $(get(params, :instance_name, "Unnamed"))")
        result = solve_milp_nanosatellite(params)
        push!(results, result)
    end
    return results
end

# Sample instance (from your original input)
instance1 = Dict(
    :instance_name => "Original_Instance",
    :J => 1:13,
    :T => 1:120,
    :r_t => Dict(t => v for (t, v) in enumerate([
        3.899666448, 3.517488054, 3.07220328, 2.571354108, 2.784530538, 2.980929906, 3.319857342,
        3.902283054, 4.477782456, 5.03696655, 5.57029242, 6.068678904, 6.523506594, 6.926771754,
        7.271548074, 7.551370998, 7.761007314, 7.896147318, 7.95371265, 7.931856294, 7.829962578,
        7.648801092, 7.390218852, 7.0571403, 6.654029058, 6.954323076, 7.250923062, 7.49118906,
        7.744999842, 8.128255662, 8.441478792, 8.681283036, 8.845975296, 8.9349399, 8.948638602,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        6.809794074, 6.832112184, 7.190895042, 7.507966122, 7.775783442, 7.987882446, 8.138722086,
        8.40238362, 8.689132854, 8.902155366, 9.03883455, 9.098400816, 9.081008082, 8.987887692,
        8.82181017, 8.586777384, 8.287560792, 7.930163196, 7.521356988, 7.068991986, 6.581379762,
        6.067293642, 5.535814788, 4.996793952, 4.638165012, 4.495021272, 4.272609762, 3.974470596,
        3.606144822, 3.173327406, 2.68356033, 2.720654568, 2.932753572, 3.195029844, 3.777455556,
        4.354801974, 4.9176801, 5.4563931, 5.961859812, 6.425460828, 6.839192412, 7.195512582,
        7.4881107, 7.711445718, 7.861054014, 7.933549392, 7.926930918, 7.840275084, 7.674043644,
        7.429929696, 7.110703764
    ])),
    :u_j => Dict(j => v for (j, v) in enumerate([11, 2, 12, 6, 3, 4, 9, 10, 7, 1, 13, 5, 8])),
    :q_j => Dict(j => v for (j, v) in enumerate([0.30924, 0.30924, 0.38155, 0.02, 0.02, 0.02, 0.02, 0.45386, 0.02, 0.9279, 0.9279, 0.7093, 0.8186])),
    :min_statup_j => Dict(j => v for (j, v) in enumerate([9, 14, 15, 12, 14, 11, 12, 15, 9, 4, 3, 5, 5])),
    :max_statup_j => Dict(j => v for (j, v) in enumerate([57, 59, 25, 55, 64, 13, 41, 83, 61, 25, 26, 17, 21])),
    :min_cpu_time_j => Dict(j => v for (j, v) in enumerate([2, 4, 2, 3, 2, 1, 3, 3, 3, 11, 10, 12, 10])),
    :max_cpu_time_j => Dict(j => v for (j, v) in enumerate([5, 6, 6, 7, 5, 5, 4, 7, 5, 31, 37, 64, 15])),
    :min_periodo_job_j => Dict(j => v for (j, v) in enumerate([5, 4, 4, 6, 7, 7, 3, 3, 7, 12, 11, 12, 12])),
    :max_periodo_job_j => Dict(j => v for (j, v) in enumerate([7, 14, 18, 15, 9, 12, 19, 22, 8, 56, 30, 43, 45])),
    :win_min_j => Dict(j => v for (j, v) in enumerate([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])),
    :win_max_j => Dict(j => v for (j, v) in enumerate([120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120, 120])),
    :V_b => 3.6,
    :γ => 2.0,
    :Q => 6.0,
    :e => 0.9,
    :ρ => 0.5,
    :ΔSoC => 0.05,
    :SoC_1 => 0.75
)

instance2 = Dict(
    :instance_name => "New_Instance",
    :J => 1:13,
    :T => 1:97,
    :r_t => Dict(t => v for (t, v) in enumerate([
        9.055149858, 9.09886257, 9.0657702, 8.957411928, 8.776866114, 8.527980708, 8.21614284,
        7.847355312, 7.428698352, 6.96786786, 6.473637162, 5.954625666, 5.42022237, 4.879816272,
        4.610305854, 4.450846806, 4.212581742, 3.899666448, 3.517488054, 3.07220328, 2.571354108,
        2.784530538, 2.980929906, 3.319857342, 3.902283054, 4.477782456, 5.03696655, 5.57029242,
        6.068678904, 6.523506594, 6.926771754, 7.271548074, 7.551370998, 7.761007314, 7.896147318,
        7.95371265, 7.931856294, 7.829962578, 7.648801092, 7.390218852, 7.0571403, 6.654029058,
        6.954323076, 7.250923062, 7.49118906, 7.744999842, 8.128255662, 8.441478792, 8.681283036,
        8.845975296, 8.9349399, 8.948638602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.809794074, 6.832112184, 7.190895042,
        7.507966122, 7.775783442, 7.987882446, 8.138722086, 8.40238362, 8.689132854, 8.902155366,
        9.03883455
    ])),
    :u_j => Dict(j => v for (j, v) in enumerate([7, 10, 13, 9, 11, 12, 1, 6, 5, 2, 8, 4, 3])),
    :q_j => Dict(j => v for (j, v) in enumerate([0.30924, 0.23693, 0.23693, 0.16462, 0.45386, 0.09231, 0.45386, 0.30924, 0.30924, 0.6, 0.6, 0.7093, 0.8186])),
    :min_statup_j => Dict(j => v for (j, v) in enumerate([13, 10, 9, 8, 8, 13, 9, 12, 11, 5, 2, 5, 5])),
    :max_statup_j => Dict(j => v for (j, v) in enumerate([54, 45, 71, 55, 74, 64, 50, 52, 71, 6, 3, 16, 21])),
    :min_cpu_time_j => Dict(j => v for (j, v) in enumerate([2, 2, 1, 3, 2, 3, 1, 2, 2, 5, 7, 10, 7])),
    :max_cpu_time_j => Dict(j => v for (j, v) in enumerate([5, 4, 5, 4, 3, 4, 5, 5, 4, 30, 22, 43, 24])),
    :min_periodo_job_j => Dict(j => v for (j, v) in enumerate([5, 6, 2, 3, 4, 4, 2, 4, 5, 9, 9, 11, 11])),
    :max_periodo_job_j => Dict(j => v for (j, v) in enumerate([10, 7, 2, 10, 5, 10, 9, 8, 6, 45, 57, 36, 87])),
    :win_min_j => Dict(j => v for (j, v) in enumerate([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])),
    :win_max_j => Dict(j => v for (j, v) in enumerate([97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97, 97])),
    :V_b => 3.6,
    :γ => 2.0,
    :Q => 6.0,
    :e => 0.9,
    :ρ => 0.5,
    :ΔSoC => 0.05,
    :SoC_1 => 0.75
)


# List of instances 
instances = [instance1, instance2]

# Run solver for all instances
results = solve_multiple_instances(instances)

# Summarize results
println("\nSummary of Results:")
for (idx, result) in enumerate(results)
    println("Instance $idx: $(result[:instance_name])")
    println("  Status: $(result[:status])")
    println("  Objective: $(result[:objective] === nothing ? "N/A" : result[:objective])")
    println("  Solve Time: $(result[:solve_time]) seconds")
    if result[:status] == "Optimal"
        println("  Final SoC: ", result[:SoC][instances[idx][:T][end]])
    end
    println()
end