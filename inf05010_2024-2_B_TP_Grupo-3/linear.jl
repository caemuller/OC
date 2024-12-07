using JuMP
using HiGHS
using Printf

function read_instance(filename::String)
    # Novo formato:
    # Linha 1: n
    # Linha 2: m
    # Próximas n linhas: l_i u_i
    open(filename, "r") do f
        line = readline(f)
        n = parse(Int, line)
        line = readline(f)
        m = parse(Int, line)
        L = Vector{Int}(undef, n)
        U = Vector{Int}(undef, n)
        for i in 1:n
            line = readline(f)
            li, ui = parse.(Int, split(line))
            L[i] = li
            U[i] = ui
        end
        return n, m, L, U
    end
end

function solve_integer_problem(filename::String, seed::Int, time_limit::Float64)
    # Ler a instância
    n, m, L, U = read_instance(filename)

    model = Model(HiGHS.Optimizer)
    set_optimizer_attribute(model, "time_limit", time_limit)
    set_attribute(model, "random_seed", seed)

    # Criação das variáveis y[i,k]
    y = [ @variable(model, base_name = "y_$(i)_", [k=1:U[i]], Bin) for i in 1:n ]

    # Restrição de monotonicidade: y[i,k] <= y[i,k-1]
    for i in 1:n
        for k in 2:U[i]
            @constraint(model, y[i][k] .<= y[i][k-1])
        end
    end

    # Restrição de limites: l_i ≤ sum_k y[i,k] ≤ u_i
    for i in 1:n
        @constraint(model, sum(y[i][k] for k=1:U[i]) >= L[i])
        @constraint(model, sum(y[i][k] for k=1:U[i]) <= U[i])
    end

    # Soma total de bolas:
    @constraint(model, sum(sum(y[i][k] for k=1:U[i]) for i=1:n) == m)

    # Função objetivo:
    @objective(model, Max, sum(sum(k*y[i][k] for k=1:U[i]) for i=1:n))

    # Otimizar
    optimize!(model)

    status = termination_status(model)

    # Checar se há solução viável encontrada
    if has_values(model)
        best_value = objective_value(model)
        bound = objective_bound(model)

        # Construção da solução x_i a partir de y:
        x = zeros(Int, n)
        for i in 1:n
            for k in 1:U[i]
                if value(y[i][k]) > 0.5
                    x[i] += 1
                end
            end
        end

        @printf "Status: %s\n" string(status)
        @printf "Melhor valor encontrado: %.2f\n" best_value
        @printf "Bound: %.2f\n" bound
        @printf "Solução: %s\n" string(x)
        @printf "Tempo decorrido: %.2f\n" solve_time(model)

        return x, best_value
    else
        # Nenhuma solução foi encontrada dentro do limite de tempo
        @printf "Status: %s\n" string(status)
        @printf "Nenhuma solução viável encontrada dentro do limite de tempo.\n"
        @printf "Tempo decorrido: %.2f\n" solve_time(model)
        return nothing, -Inf
    end
end

# Programa principal
if length(ARGS) < 3
    println("Uso: julia solve_integer.jl <arquivo_entrada> <seed> <time_limit>")
    exit(1)
end

filename = ARGS[1]
seed = parse(Int, ARGS[2])
time_limit = parse(Float64, ARGS[3])

solve_integer_problem(filename, seed, time_limit)