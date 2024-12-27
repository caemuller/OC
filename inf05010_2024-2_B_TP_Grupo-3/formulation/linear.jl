using JuMP
using HiGHS
using Printf
using MathOptInterface
using CSV
using DataFrames

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

function solve_integer_problem(filename::String, seed::Int, time_limit::Float64, csv::Bool=false)
    #-------------------------------------------------------------------------------
    # INICIALIZAÇÃO:

    # Ler a instância
    n, m, L, U = read_instance(filename)

    # Criar o modelo
    model = Model(HiGHS.Optimizer)
    
    # Ajustar atributos para tentar respeitar o tempo
    set_optimizer_attribute(model, "time_limit", time_limit)
    
    # Desativar presolve para evitar travar nessa fase
    set_optimizer_attribute(model, "presolve", "off")
    
    # Ajustar seed
    set_attribute(model, "random_seed", seed)
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    # Criação das variáveis y[i,k]:
    y = [ @variable(model, base_name = "y_$(i)_", [k=1:U[i]], Bin) for i in 1:n ]
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    # RESTRIÇÕES:
    
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
    #-------------------------------------------------------------------------------


    #-------------------------------------------------------------------------------
    # Função objetivo:
    @objective(model, Max, sum(sum(k*y[i][k] for k=1:U[i]) for i=1:n))
    #-------------------------------------------------------------------------------

    #-------------------------------------------------------------------------------
    # OTIMIZAÇÃO:

    optimize!(model)

    status = termination_status(model)

    # Contar o número de iterações
    num_iterations = MOI.get(model, MOI.SimplexIterations())
    solve_time = MOI.get(model, MOI.SolveTimeSec())

    # Verificar se alguma solução viável foi encontrada
    bound = MOI.get(model, MOI.ObjectiveBound())
    if has_values(model)
        best_value = objective_value(model)

        # Construção da solução x_i a partir de y:
        x = zeros(Int, n)
        for i in 1:n
            for k in 1:U[i]
                if value(y[i][k]) > 0.5
                    x[i] += 1
                end
            end
        end

        # Exibir resultados
        @printf "Status: %s\n" string(status)
        @printf "Melhor valor encontrado: %.2f\n" best_value
        @printf "Bound: %.2f\n" bound
        @printf "Solução: %s\n" string(x)
        @printf "Tempo decorrido: %.2f\n" solve_time
        @printf "Número de iterações: %d\n" num_iterations

        return x, best_value, solve_time, num_iterations, status, bound
    else
        # Nenhuma solução viável encontrada (pode ter estourado o tempo)
        @printf "Status: %s\n" string(status)
        @printf "Nenhuma solução viável encontrada dentro do limite de tempo.\n"
        @printf "Tempo decorrido: %.2f\n" round(solve_time, digits=2)
        @printf "Número de iterações: %d\n" num_iterations
        return  nothing, -Inf, solve_time, num_iterations, status, bound
    end
end

function main()
    if length(ARGS) < 4
        println("Uso: julia Linear.jl <file> <seed> <time_limit> <optional: -csv>")
        return
    end

    filename = ARGS[1]
    seed = parse(Int, ARGS[2])
    time_limit = parse(Float64, ARGS[3])

    solve_integer_problem(filename, seed, time_limit)
end

main()