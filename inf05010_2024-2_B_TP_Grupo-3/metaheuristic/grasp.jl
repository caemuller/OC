using Random
using Printf
using Statistics

########## Funções auxiliares ##########

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

function solution_value(x)
    # Valor da solução = sum_{i} (x_i*(x_i+1)/2)
    val = 0
    for xi in x
        val += xi*(xi+1) ÷ 2
    end
    return val
end

function feasible(x, L, U, m)
    # Verifica se a solução é factível
    if sum(x) != m
        return false
    end
    for i in eachindex(x)
        if x[i] < L[i] || x[i] > U[i]
            return false
        end
    end
    return true
end

########## Construção Gulosa-Randômica (GRASP) ##########
function construct_solution(n, m, L, U; alpha=0.1)
    x = copy(L)
    bolas_colocadas = sum(L)
    sobra = m - bolas_colocadas

    priority_queue = [(i, x[i] + 1) for i in 1:n if x[i] < U[i]]
    while sobra > 0 && !isempty(priority_queue)
        # Sort only once to determine the cutoff
        sort!(priority_queue, by = t -> t[2], rev = true)
        melhor_ganho = priority_queue[1][2]
        cutoff = melhor_ganho - alpha * melhor_ganho
        RCL = [t[1] for t in priority_queue if t[2] >= cutoff]

        escolhido = RCL[rand(1:length(RCL))]
        x[escolhido] += 1
        sobra -= 1

        # Update the priority queue
        priority_queue = [(i, x[i] + 1) for i in 1:n if x[i] < U[i]]
    end

    return x
end

########## Busca Local ##########

function local_search(x, L, U, max_no_improve)
    best_x = copy(x)
    best_val = solution_value(x)
    no_improve = 0

    # Estratégia simples: tenta mover uma bola de i para j, se factível e melhora
    # Repetir até não melhorar por um número de tentativas
    # (Para não ser muito lento, limitamos o número de iterações)
    improved = true
    while improved && no_improve < max_no_improve
        improved = false
        for i in eachindex(x)
            for j in eachindex(x)
                if i != j
                    # Tenta mover uma bola de i para j
                    if x[i] > L[i] && x[j] < U[j]
                        old_val = best_val
                        # Tenta a mudança
                        x[i] -= 1
                        x[j] += 1
                        new_val = solution_value(x)
                        if new_val > best_val
                            best_val = new_val
                            best_x = copy(x)
                            improved = true
                            no_improve = 0
                        else
                            # Reverte se não melhorou
                            x[i] += 1
                            x[j] -= 1
                        end
                    end
                end
            end
        end
        if !improved
            no_improve += 1
        end
    end
    return best_x
end

########## GRASP Completo ##########

function grasp(filename, max_iterations, time_limit, seed)
    @printf("GRASP para o arquivo %s\n", filename)
    n, m, L, U = read_instance(filename)
    alpha=0.1
    max_no_improve=100
    Random.seed!(seed)
    start_time = time()
    best_x = nothing
    best_val = -Inf
    terminated_by_time = false
    num_iterations = 0
    status = "nothing"

    for iter in 1:max_iterations
        if time() - start_time > time_limit
            # se passamos do limite de tempo, parar
            terminated_by_time = true
            break
        end

        # Construção
        x = construct_solution(n, m, L, U; alpha=alpha)
        # Garantir factibilidade (deveria ser sempre, mas caso não seja, continue)
        if !feasible(x,L,U,m)
            continue
        end

        # Busca local
        x_local = local_search(x, L, U, max_no_improve)
        val = solution_value(x_local)

        # Se for melhor que o melhor conhecido, imprimir e atualizar
        if val > best_val
            best_val = val
            best_x = copy(x_local)
            elapsed = time() - start_time
            #@printf("%.2f %d %s\n", elapsed, best_val, string(best_x))
            @printf("%.2f %d\n", elapsed, best_val)
        end
        num_iterations = iter
    end

    if terminated_by_time
        status = "time_limit"
    else
        status = "max_iterations"
    end

    total_time = time() - start_time
    if best_x === nothing
        println("Não encontrou solução viável.")
    else
        @printf("Status: %s\n", status)
        @printf("Valor: %d\n", best_val)
        @printf("Tempo total: %.2f s\n", total_time)
        @printf("Número de iterações: %d\n", num_iterations)
        @printf("Melhor solução final: %s\n", string(best_x))
    end
    @printf("\n\n")

    return status, best_val, total_time, num_iterations, best_x
    
end

function main()
    if length(ARGS) < 4
        println("Uso: julia solve_metaheuristica.jl <arquivo_instancia> <seed> <max_iterations> <time_limit(segundos)>")
        exit(1)
    end
    
    filename = ARGS[1]
    seed = parse(Int, ARGS[2])
    max_iterations = parse(Int, ARGS[3])
    time_limit = parse(Float64, ARGS[4])
    grasp(filename, max_iterations, time_limit, seed)

end
