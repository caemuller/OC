using JuMP
using HiGHS
using Printf

function read_instance(filename::String)
    # Formato atual:
    # Linha 1: n
    # Linha 2: m
    # Próximas n linhas: l_i u_i
    open(filename, "r") do f
        n = parse(Int, readline(f))
        m = parse(Int, readline(f))
        L = Vector{Int}(undef, n)
        U = Vector{Int}(undef, n)
        for i in 1:n
            li_ui = readline(f)
            li, ui = parse.(Int, split(li_ui))
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
    # Ajustar atributos para tentar respeitar o tempo
    set_optimizer_attribute(model, "time_limit", time_limit)
    # Desativar presolve para evitar travar nessa fase
    set_optimizer_attribute(model, "presolve", "off")
    # Ajustar semente
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
    solve_status = primal_status(model)

    # Verificar se alguma solução viável foi encontrada
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
        # Nenhuma solução viável encontrada (pode ter estourado o tempo)
        @printf "Status: %s\n" string(status)
        @printf "Nenhuma solução viável encontrada dentro do limite de tempo.\n"
        @printf "Tempo decorrido: %.2f\n" solve_time(model)
        return nothing, -Inf
    end
end

# Programa principal
if length(ARGS) < 3
    println("Uso: julia linear.jl <arquivo_entrada> <seed> <time_limit>")
    exit(1)
end

filename = ARGS[1]
seed = parse(Int, ARGS[2])
time_limit = parse(Float64, ARGS[3])

solve_integer_problem(filename, seed, time_limit)