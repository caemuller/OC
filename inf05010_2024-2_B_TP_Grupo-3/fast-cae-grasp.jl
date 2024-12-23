using Random
using Printf
using Statistics
using Base.Iterators: partition

########## Funções auxiliares ##########

function read_instance(filename::String)
    open(filename, "r") do f
        n = parse(Int, readline(f))
        m = parse(Int, readline(f))
        L, U = Vector{Int}(undef, n), Vector{Int}(undef, n)
        for i in 1:n
            li, ui = parse.(Int, split(readline(f)))
            L[i] = li
            U[i] = ui
        end
        return n, m, L, U
    end
end

function solution_value(x)
    return sum(xi * (xi + 1) ÷ 2 for xi in x)
end

function feasible(x, L, U, m)
    return sum(x) == m && all(x[i] >= L[i] && x[i] <= U[i] for i in 1:length(x))
end

function update_solution_value(x, current_val, i, change)
    old_val = x[i] * (x[i] + 1) ÷ 2
    new_xi = x[i] + change
    new_val = new_xi * (new_xi + 1) ÷ 2
    return current_val - old_val + new_val
end

########## Construção Gulosa-Randômica (GRASP) ##########

function construct_solution(n, m, L, U; alpha=0.1)
    x = copy(L)
    bolas_colocadas = sum(L)
    sobra = m - bolas_colocadas

    # Precompute the initial priority queue as a max-heap with Int64 for the gain values
    priority_queue = [(i, (x[i] + 1) * (x[i] + 2) ÷ 2 - x[i] * (x[i] + 1) ÷ 2) for i in 1:n if x[i] < U[i]]
    sort!(priority_queue, by = t -> t[2], rev = true)

    while sobra > 0 && !isempty(priority_queue)
        # Calculate cutoff dynamically
        melhor_ganho = priority_queue[1][2]
        cutoff = melhor_ganho - alpha * melhor_ganho

        # Filter the RCL (Restricted Candidate List) manually
        RCL = [t[1] for t in priority_queue if t[2] >= cutoff]

        if !isempty(RCL)
            # Randomly pick an index from the RCL
            escolhido = RCL[rand(1:length(RCL))]
            x[escolhido] += 1
            sobra -= 1

            # Calculate the new gain for the chosen index
            if x[escolhido] < U[escolhido]
                new_gain = (x[escolhido] + 1) * (x[escolhido] + 2) ÷ 2 - x[escolhido] * (x[escolhido] + 1) ÷ 2
            else
                new_gain = -1_000_000 
            end

            # Update the priority queue efficiently
            # Look for the element with the same index and update its gain
            for i in 1:length(priority_queue)
                if priority_queue[i][1] == escolhido
                    priority_queue[i] = (escolhido, new_gain)
                    break
                end
            end

            # Remove invalid elements (those with gain less than -1_000_000)
            priority_queue = filter(t -> t[2] > -1_000_000, priority_queue)

            # Re-sort the priority queue
            sort!(priority_queue, by = t -> t[2], rev = true)
        end
    end

    return x
end

########## Busca Local ##########

function local_search(x, L, U, m; max_no_improve=50)
    best_x = copy(x)
    best_val = solution_value(x)
    no_improve = 0
    n = length(x)

    while no_improve < max_no_improve
        improved = false
        for i in 1:n
            if x[i] > L[i]
                for j in 1:n
                    if i != j && x[j] < U[j]
                        x[i] -= 1
                        x[j] += 1
                        new_val = solution_value(x)
                        
                        if new_val > best_val
                            best_val = new_val
                            best_x = copy(x)
                            improved = true
                            no_improve = 0
                        else
                            x[i] += 1
                            x[j] -= 1
                        end
                    end
                end
            end
        end
        no_improve += !improved
    end
    return best_x
end

########## GRASP Completo ##########

function grasp(n, m, L, U; max_iterations=1000, alpha=0.1, time_limit=Inf, seed=1234)
    Random.seed!(seed)
    start_time = time()
    best_x = nothing
    best_val = -Inf
    terminated_by_time = false

    # Parallelize iterations of GRASP
    for iter in 1:max_iterations
        if time() - start_time > time_limit
            terminated_by_time = true
            break
        end

        x = construct_solution(n, m, L, U; alpha=alpha)
        if !feasible(x, L, U, m)
            continue
        end

        x_local = local_search(x, L, U, m; max_no_improve=50)
        val = solution_value(x_local)

        if val > best_val
            best_val = val
            best_x = copy(x_local)
            elapsed = time() - start_time
            @printf("%.2f %d %s\n", elapsed, best_val, string(best_x))
        end
    end

    if terminated_by_time
        println("Encerrado por limite de tempo.")
    else
        println("Encerrado por número máximo de iterações.")
    end

    return best_x, best_val, time() - start_time
end

########## Programa Principal ##########

if length(ARGS) < 4
    println("Uso: julia solve_metaheuristica.jl <arquivo_instancia> <seed> <max_iterations> <time_limit(segundos)>")
    exit(1)
end

filename = ARGS[1]
seed = parse(Int, ARGS[2])
max_iters = parse(Int, ARGS[3])
time_lim = parse(Float64, ARGS[4])

n, m, L, U = read_instance(filename)

best_solution, best_val, total_time = grasp(n, m, L, U; max_iterations=max_iters, alpha=0.1, time_limit=time_lim, seed=seed)

if best_solution === nothing
    println("Não encontrou solução viável.")
else
    @printf("Melhor solução final: %s\n", string(best_solution))
    @printf("Valor: %d\n", best_val)
    @printf("Tempo total: %.2f s\n", total_time)
end
