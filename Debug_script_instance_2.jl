println("Debugging script started...")
# import Pkg
# println("Installing Gurobi...")
# # Pkg.build("Gurobi")
# Pkg.add("DataStructures")
using JuMP
using Gurobi
using JuMP
using DataStructures


subs = 1
jobs = 13
T = 97
T_size = 97
tamanho = 97
recurso_p = [9.055149858, 9.09886257, 9.0657702, 8.957411928, 8.776866114, 8.527980708, 8.21614284, 7.847355312, 7.428698352, 6.96786786, 6.473637162, 5.954625666, 5.42022237, 4.879816272, 4.610305854, 4.450846806, 4.212581742, 3.899666448, 3.517488054, 3.07220328, 2.571354108, 2.784530538, 2.980929906, 3.319857342, 3.902283054, 4.477782456, 5.03696655, 5.57029242, 6.068678904, 6.523506594, 6.926771754, 7.271548074, 7.551370998, 7.761007314, 7.896147318, 7.95371265, 7.931856294, 7.829962578, 7.648801092, 7.390218852, 7.0571403, 6.654029058, 6.954323076, 7.250923062, 7.49118906, 7.744999842, 8.128255662, 8.441478792, 8.681283036, 8.845975296, 8.9349399, 8.948638602, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 6.809794074, 6.832112184, 7.190895042, 7.507966122, 7.775783442, 7.987882446, 8.138722086, 8.40238362, 8.689132854, 8.902155366, 9.03883455]
priority = [7 10 13 9 11 12 1 6 5 2 8 4 3 ]
uso_p = [0.30924 0.23693 0.23693 0.16462 0.45386 0.09231 0.45386 0.30924 0.30924 0.6 0.6 0.7093 0.8186 ]
min_statup = [13 10 9 8 8 13 9 12 11 5 2 5 5 ]
max_statup = [54 45 71 55 74 64 50 52 71 6 3 16 21 ]
min_cpu_time = [2 2 1 3 2 3 1 2 2 5 7 10 7 ]
max_cpu_time = [5 4 5 4 3 4 5 5 4 30 22 43 24 ]
min_periodo_job = [5 6 2 3 4 4 2 4 5 9 9 11 11 ]
max_periodo_job = [10 7 2 10 5 10 9 8 6 45 57 36 87 ]
win_min = [0 0 0 0 0 0 0 0 0 0 0 0 0 ]
win_max = [97 97 97 97 97 97 97 97 97 97 97 97 97 ]
colunas_ = [[], [], [], [], [], [], [], [], [], [], [], [], [] ]
colunas = [[[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]] ]
colunas_seed = [[[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]], [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]] ]

using JuMP, Gurobi, DataStructures

# Fallback data (replace with actual data)
J = 1:13
T = 1:97
# recurso_p = Dict(t => 10.0 for t in T)  # Example: constant resource
# priority = Dict(j => 10 + j for j in J)  # Example: increasing priority
# uso_p = Dict(j => 1.0 for j in J)  # Example: constant usage
# min_statup = Dict(j => 9 for j in J)
# max_statup = Dict(j => 15 for j in J)
# min_cpu_time = Dict(j => 2 for j in J)
# max_cpu_time = Dict(j => 5 for j in J)
# min_periodo_job = Dict(j => 5 for j in J)
# max_periodo_job = Dict(j => 10 for j in J)
# win_min = Dict(j => 0 for j in J)
# win_max = Dict(j => 120 for j in J)
colunas_seed = Dict(j => [ones(Int, 97)] for j in J)  # Fallback: all-ones profile
V_b = 3.6
γ = 2.0
Q = 6.0
e = 0.9
ρ = 0.5
ΔSoC = 0.05
SoC_1 = 0.75
M = 1e6

# Derived data
# r_t = Dict(t => recurso_p[t] for t in T)
# u_j = Dict(j => priority[j] for j in J)
# q_j = Dict(j => uso_p[j] for j in J)
# min_statup = Dict(j => min_statup[j] for j in J)
# max_statup = Dict(j => max_statup[j] for j in J)
# min_cpu_time = Dict(j => min_cpu_time[j] for j in J)
# max_cpu_time = Dict(j => max_cpu_time[j] for j in J)
# min_periodo_job = Dict(j => min_periodo_job[j] for j in J)
# max_periodo_job = Dict(j => max_periodo_job[j] for j in J)
# win_min = Dict(j => win_min[j] for j in J)
# win_max = Dict(j => win_max[j] for j in J)

r_t = Dict(t => recurso_p[t] for t in T)
u_j = Dict(j => priority[j] for j in J)
q_j = Dict(j => uso_p[j] for j in J)
min_statup = Dict(j => min_statup[j] for j in J)
max_statup = Dict(j => max_statup[j] for j in J)
min_cpu_time = Dict(j => min_cpu_time[j] for j in J)
max_cpu_time = Dict(j => max_cpu_time[j] for j in J)
min_periodo_job = Dict(j => min_periodo_job[j] for j in J)
max_periodo_job = Dict(j => max_periodo_job[j] for j in J)
win_min = Dict(j => win_min[j] for j in J)
win_max = Dict(j => win_max[j] for j in J)

# Initial profiles
K_star = Dict(j => [1] for j in J)
θ_k = Dict(j => Dict(1 => colunas_seed[j][1]) for j in J)
c_k = Dict(j => Dict{Int, Float64}() for j in J)
q_k = Dict(j => Dict{Int, Vector{Float64}}() for j in J)
for j in J
    c_k[j][1] = u_j[j] * sum(θ_k[j][1])
    q_k[j][1] = [q_j[j] * θ_k[j][1][t] for t in T]
end

# Node structure
mutable struct Node
    id::Int
    UB::Float64
    L0::Set{Tuple{Int,Int}}
    L1::Set{Tuple{Int,Int}}
    is_root::Bool
end

# solve_RMP_l
function solve_RMP_l(J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, L0, L1, M, is_root)
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "OutputFlag", 1)

    @variable(model, ξ[j in J, k in K_star[j]] >= 0)
    @variable(model, 0 <= α[t in T] <= 1)
    @variable(model, b[t in T])
    @variable(model, i[t in T])
    @variable(model, ρ <= SoC[t in T] <= 1)

    @constraint(model, SoC[1] == SoC_1)

    if is_root
        @objective(model, Max, sum(c_k[j][k] * ξ[j, k] for j in J, k in K_star[j]) - M * sum(ξ[j, 1] for j in J))
    else
        @objective(model, Max, sum(c_k[j][k] * ξ[j, k] for j in J, k in K_star[j]))
    end

    @constraint(model, select_profile[j in J], sum(ξ[j, k] for k in K_star[j]) == 1)
    @constraint(model, power_limit[t in T], sum(q_k[j][k][t] * ξ[j, k] for j in J, k in K_star[j]) + γ * V_b * α[t] <= r_t[t] + γ * V_b)
    @constraint(model, power_balance[t in T], sum(q_k[j][k][t] * ξ[j, k] for j in J, k in K_star[j]) + b[t] == r_t[t])
    @constraint(model, battery_current[t in T], i[t] == b[t] / V_b)
    @constraint(model, soc_update[t in T[1:end-1]], SoC[t+1] == SoC[t] + i[t] * e / (60 * Q))
    @constraint(model, soc_upper, SoC[T[end]] <= SoC_1 * (1 + ΔSoC))
    @constraint(model, soc_lower, SoC[T[end]] >= SoC_1 * (1 - ΔSoC))
    @constraint(model, branch_zero[(j, t) in L0], sum(θ_k[j][k][t] * ξ[j, k] for k in K_star[j]) == 0)
    @constraint(model, branch_one[(j, t) in L1], sum(θ_k[j][k][t] * ξ[j, k] for k in K_star[j]) == 1)

    # if haskey(model, :power_balance)
    #     println("power_balance constraint exists")
    #     println("power_balance: ", model[:power_balance])
    # else
    #     error("power_balance constraint not defined")
    # end

    optimize!(model)
    println("Status: ", termination_status(model))

    v_dual = -dual.(power_balance)
    # println(v_dual)

    if termination_status(model) == MOI.OPTIMAL
        ξ_val = value.(ξ)
        α_val = value.(α)
        b_val = value.(b)
        i_val = value.(i)
        SoC_val = value.(SoC)
        μ = -dual.(select_profile)
        pi_dual = -dual.(power_limit)
        ν_val = v_dual
        ζ0 = Dict((j, t) => -dual(branch_zero[(j, t)]) for (j, t) in L0)
        ζ1 = Dict((j, t) => -dual(branch_one[(j, t)]) for (j, t) in L1)
        obj_value = objective_value(model)

       

        return Dict(
            "status" => "Optimal",
            "objective" => obj_value,
            "ξ" => ξ_val,
            "α" => α_val,
            "b" => b_val,
            "i" => i_val,
            "SoC" => SoC_val,
            "μ" => μ,
            "pi_dual" => pi_dual,
            "ν_dual" => ν_val,
            "ζ0" => ζ0,
            "ζ1" => ζ1
        )
    else
        return Dict("status" => "Infeasible")
    end
end

# solve_PS_j
function solve_PS_j(j, T, u_j, q_j, μ_j, pi_dual, ν_dual, ζ0, ζ1, min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max)
    model = Model(Gurobi.Optimizer)
    set_optimizer_attribute(model, "OutputFlag", 0)

    @variable(model, x[t in T], Bin)
    @variable(model, φ[t in T], Bin)

    println("we are in Psj iteration: ", j)
    # v = ν_dual
    # println("ν_dual: ", v)

    @objective(model, Max,
        u_j[j] * sum(x[t] for t in T) - μ_j -
        q_j[j] * sum((pi_dual[t] + ν_dual[t]) * x[t] for t in T) -
        sum(ζ0[(j, t)] * x[t] for (j, t) in keys(ζ0)) -
        sum(ζ1[(j, t)] * x[t] for (j, t) in keys(ζ1))
    )

    @constraint(model, φ[T[1]] >= x[T[1]])
    @constraint(model, [t in T[2:end]], φ[t] >= x[t] - x[t-1])
    @constraint(model, [t in T], φ[t] <= x[t])
    @constraint(model, [t in T[2:end]], φ[t] <= 2 - x[t] - x[t-1])
    @constraint(model, sum(φ[t] for t in T) >= min_statup[j])
    @constraint(model, sum(φ[t] for t in T) <= max_statup[j])
    @constraint(model, [t in 1:(T[end] - min_cpu_time[j] + 1)],
        sum(x[l] for l in t:(t + min_cpu_time[j] - 1)) >= min_cpu_time[j] * φ[t])
    @constraint(model, [t in 1:(T[end] - max_cpu_time[j])],
        sum(x[l] for l in t:(t + max_cpu_time[j])) <= max_cpu_time[j])
    @constraint(model, [t in (T[end] - min_cpu_time[j] + 2):T[end]],
        sum(x[l] for l in t:T[end]) >= (T[end] - t + 1) * φ[t])
    @constraint(model, [t in (1 + win_min[j]):(win_max[j] - min_periodo_job[j])],
        sum(φ[l] for l in t:(t + min_periodo_job[j] - 1)) <= 1)
    @constraint(model, [t in (1 + win_min[j]):(win_max[j] - max_periodo_job[j])],
        sum(φ[l] for l in t:(t + max_periodo_job[j] - 1)) >= 1)
    @constraint(model, [t in 1:win_min[j]], x[t] == 0)
    @constraint(model, [t in win_max[j]:T[end]], x[t] == 0)

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        x_val = value.(x)
        reduced_cost = objective_value(model)
        profile = [round(Int, x_val[t]) for t in T]
        if reduced_cost > 1e-6
            println("Reduced cost: ", reduced_cost)
            return Dict("reduced_cost" => reduced_cost, "profile" => profile)
        else
            println("Reduced cost: ", reduced_cost)
            return Dict("reduced_cost" => reduced_cost)
        end
    else
        println("Reduced cost: infinity")
        return Dict("reduced_cost" => -Inf)
    end
    
end

# solve_HRMP_l
function solve_HRMP_l(J, T, K_star, θ_k, c_k, q_k, r_t, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, L0, L1)
    model = Model(Gurobi.Optimizer)
    # set_optimizer_attribute(model, "OutputFlag", 0)
    # set_optimizer_attribute(model, "TimeLimit", 60)
    # set_optimizer_attribute(model, "MIPGap", 0.05)

    @variable(model, ξ[j in J, k in K_star[j]], Bin)
    @variable(model, 0 <= α[t in T] <= 1)
    @variable(model, b[t in T])
    @variable(model, i[t in T])
    @variable(model, ρ <= SoC[t in T] <= 1)

    @constraint(model, SoC[1] == SoC_1)
    @objective(model, Max, sum(c_k[j][k] * ξ[j, k] for j in J, k in K_star[j]))

    @constraint(model, select_profile[j in J], sum(ξ[j, k] for k in K_star[j]) == 1)
    @constraint(model, power_limit[t in T], sum(q_k[j][k][t] * ξ[j, k] for j in J, k in K_star[j]) + γ * V_b * α[t] <= r_t[t] + γ * V_b)
    @constraint(model, power_balance[t in T], sum(q_k[j][k][t] * ξ[j, k] for j in J, k in K_star[j]) + b[t] == r_t[t])
    @constraint(model, battery_current[t in T], i[t] == b[t] / V_b)
    @constraint(model, soc_update[t in T[1:end-1]], SoC[t+1] == SoC[t] + i[t] * e / (60 * Q))
    @constraint(model, soc_upper, SoC[T[end]] <= SoC_1 * (1 + ΔSoC))
    @constraint(model, soc_lower, SoC[T[end]] >= SoC_1 * (1 - ΔSoC))
    @constraint(model, branch_zero[(j, t) in L0], sum(θ_k[j][k][t] * ξ[j, k] for k in K_star[j]) == 0)
    @constraint(model, branch_one[(j, t) in L1], sum(θ_k[j][k][t] * ξ[j, k] for k in K_star[j]) == 1)

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL || termination_status(model) == MOI.TIME_LIMIT
        if has_values(model)
            ξ_val = value.(ξ)
            obj_value = objective_value(model)
            return Dict("feasible" => true, "objective" => obj_value, "ξ" => ξ_val)
        else
            return Dict("feasible" => false)
        end
    else
        return Dict("feasible" => false)
    end
end

# Solves a node in the branch-and-price algorithm for nanosatellite scheduling
function node(l, LB, UB_l, J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, L0, L1, M, is_root, min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max)
    # Initialize variables
    new_columns_added = true
    iteration = 0
    Z_RMP = Inf  # Ensure Z_RMP is defined to fix UndefVarError and IDE grey-out
    x_jt = Dict{Tuple{Int,Int},Float64}()  # Initialize x_jt to avoid potential issues
    rmp_result = nothing
    try
        # Column generation loop
        while new_columns_added
            iteration += 1
            println("Column generation iteration $iteration for node $l")
            
            # Solve restricted master problem
            rmp_result = solve_RMP_l(J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, L0, L1, M, is_root)
            if !haskey(rmp_result, "status")
                println("Iteration $iteration: rmp_result missing 'status' key")
                return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
            end
            println("RMP status: ", rmp_result["status"])
            if rmp_result["status"] == "Infeasible"
                println("Iteration $iteration: RMP infeasible")
                return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
            end

            # Get objective value
            if !haskey(rmp_result, "objective")
                println("Iteration $iteration: rmp_result missing 'objective' key")
                return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
            end
            Z_RMP = rmp_result["objective"]
            println("Iteration $iteration: Z_RMP = $Z_RMP")

            # Generate duals for pricing subproblem
            σ = Dict(
                "μ" => rmp_result["μ"],
                "pi_dual" => rmp_result["pi_dual"],
                "ν_dual" => rmp_result["ν_dual"],  # Fixed typo: v_dual → ν_dual
                "ζ0" => rmp_result["ζ0"],
                "ζ1" => rmp_result["ζ1"]
            )

            # Pricing subproblem to generate new columns
            new_columns_added = false
            max_reduced_cost = -Inf
            for j in J
                ps_result = solve_PS_j(j, T, u_j, q_j, σ["μ"][j], σ["pi_dual"], σ["ν_dual"], σ["ζ0"], σ["ζ1"], min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max)

                if !haskey(ps_result, "reduced_cost")
                    println("Iteration $iteration: ps_result missing 'reduced_cost' key")
                    continue
                end

                if ps_result["reduced_cost"] > 0
                    new_columns_added = true
                    max_reduced_cost = max(max_reduced_cost, ps_result["reduced_cost"])
                    k_new = length(K_star[j]) + 1
                    K_star[j] = push!(K_star[j], k_new)
                    θ_k[j][k_new] = ps_result["profile"]
                    c_k[j][k_new] = u_j[j] * sum(ps_result["profile"])
                    q_k[j][k_new] = [q_j[j] * ps_result["profile"][t] for t in T]
                    println("Task $j: Added profile $k_new, Reduced cost = $(ps_result["reduced_cost"]), Active periods = $(sum(ps_result["profile"]))")
                end
            end



            # Check for pruning based on lower bound
            
            if Z_RMP <= LB
                println("Iteration $iteration: Z_RMP <= LB, pruning node")
                return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
            end

            # # Update upper bound
            # if Z_RMP < UB_l
            #     UB_l = Z_RMP
            #     println("Iteration $iteration: Updated UB_l = $UB_l")
            # end

            if is_root && Z_RMP < 0  # Skip negative Z_RMP in root node
                println("Iteration $iteration: Skipping UB_l update for root node with negative Z_RMP = $Z_RMP")
            elseif Z_RMP < UB_l
                UB_l = Z_RMP
                println("Iteration $iteration: Updated UB_l = $Z_RMP")
            end

        end

        # Post-column generation: Solve heuristic RMP
        hrmp_result = solve_HRMP_l(J, T, K_star, θ_k, c_k, q_k, r_t, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, L0, L1)
        if haskey(hrmp_result, "feasible") && hrmp_result["feasible"]
            Z_H = hrmp_result["objective"]
            if Z_H > LB
                LB = Z_H
                println("After loop: Updated LB = $LB from HRMP")
            end
            if Z_H == UB_l
                println("After loop: Optimal solution found, Z_H = UB_l")
                return 1, LB, UB_l, [], K_star, θ_k, c_k, q_k
            end
        end

        # Compute fractional solutions for branching
        
        if rmp_result === nothing
            println("Error: rmp_result is undefined after column generation")
            return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
        end
        x_jt = Dict((j, t) => sum(θ_k[j][k][t] * rmp_result["ξ"][j, k] for k in K_star[j]) for j in J, t in T)
        println("x_jt computed: ", x_jt)
        
        min_fractional = Inf
        selected_jt = (0, 0)
        for j in J, t in T
            fractional = abs(0.5 - x_jt[j, t])
            if fractional < min_fractional
                min_fractional = fractional
                selected_jt = (j, t)
            end
        end

        # Branch if fractional solution exists
        if min_fractional < 0.499
            new_nodes = [
                (l * 2, copy(L0) ∪ [selected_jt], copy(L1)),      # x_jt = 0
                (l * 2 + 1, copy(L0), copy(L1) ∪ [selected_jt])   # x_jt = 1
            ]
            println("After loop: Branching on (j,t) = $selected_jt, min_fractional = $min_fractional")
            return 2, LB, UB_l, new_nodes, K_star, θ_k, c_k, q_k
        else
            if Z_RMP > LB
                LB = Z_RMP
                println("After loop: Updated LB = $LB")
            end
            println("After loop: Integer solution found")
            return 1, LB, UB_l, [], K_star, θ_k, c_k, q_k
        end
    catch e
        println("Error in node function: ", e)
        return 0, LB, UB_l, [], K_star, θ_k, c_k, q_k
    end
end

# branch_and_price

function branch_and_price(J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, M, min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max)
    nodes = Vector{Int}()  # Stack for DFS (LIFO)
    node_data = Dict{Int, Node}()
    l = 1
    LB = -Inf
    UB_l = Inf  # Placeholder, not used for prioritization
    L0 = Set{Tuple{Int,Int}}()
    L1 = Set{Tuple{Int,Int}}()
    is_root = true
    node_data[l] = Node(l, UB_l, L0, L1, is_root)
    push!(nodes, l)

    while !isempty(nodes)
        l = pop!(nodes)  # LIFO: Get most recent node
        current_node = node_data[l]
        println("Processing node $(current_node.id)")

        result, LB, UB_l, new_nodes, K_star, θ_k, c_k, q_k = node(
            current_node.id, LB, current_node.UB, J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, current_node.L0, current_node.L1, M, current_node.is_root,
            min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max
        )

        if result == 0
            println("Node $(current_node.id) pruned")
        elseif result == 1
            println("Optimal integer solution found at node $(current_node.id)")
            return K_star, θ_k, c_k, q_k, LB
        else
            println("Node $(current_node.id) processed, new nodes: ", [n[1] for n in new_nodes])
            println("Updated LB: $LB")
            
            # DFS: Process left child immediately, push right child to stack
            left_l, left_L0, left_L1 = new_nodes[1]  # Left child
            right_l, right_L0, right_L1 = new_nodes[2]  # Right child
            
            # Store left node in node_data
            node_data[left_l] = Node(left_l, UB_l, left_L0, left_L1, false)
            
            # Process left child recursively
            println("Processing left child node $left_l")
            left_result, LB, left_UB, left_new_nodes, K_star, θ_k, c_k, q_k = node(
                left_l, LB, UB_l, J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, left_L0, left_L1, M, false,
                min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max
            )
            
            if left_result == 0
                println("Left child node $left_l pruned")
                # Push right child to stack
                node_data[right_l] = Node(right_l, UB_l, right_L0, right_L1, false)
                push!(nodes, right_l)
                println("Pushed right child node $right_l to stack")
            elseif left_result == 1
                println("Optimal integer solution found at left child node $left_l")
                return K_star, θ_k, c_k, q_k, LB
            else
                println("Left child node $left_l processed, new nodes: ", [n[1] for n in left_new_nodes])
                # Push left child's new nodes to stack
                for (new_l, new_L0, new_L1) in reverse(left_new_nodes)  # Reverse to maintain DFS order
                    node_data[new_l] = Node(new_l, UB_l, new_L0, new_L1, false)
                    push!(nodes, new_l)
                end
                # Push right child to stack
                node_data[right_l] = Node(right_l, UB_l, right_L0, right_L1, false)
                push!(nodes, right_l)
                println("Pushed right child node $right_l to stack")
            end
        end
    end

    println("No feasible solution found")
    return K_star, θ_k, c_k, q_k, LB
end

# Run
K_star, θ_k, c_k, q_k, LB = branch_and_price(
    J, T, K_star, θ_k, c_k, q_k, r_t, u_j, q_j, V_b, γ, Q, e, ρ, ΔSoC, SoC_1, M,
    min_statup, max_statup, min_cpu_time, max_cpu_time, min_periodo_job, max_periodo_job, win_min, win_max
)

# Print final results
println("Final LB: ", LB)
println("Number of profiles per task: ", Dict(j => length(K_star[j]) for j in J))
