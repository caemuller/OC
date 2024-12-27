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


########## Imprime problema original ###############
function print_problem(n, m, L, U)


    println("===============================")
    println("||       Bins and balls      ||")
    println("===============================")
    @printf("|| balls = %d \n", m)
    @printf("|| bins = %d \n", n)
    for i in 1:n
        #println("||    " + L[1] + ", " + U[I])
        @printf("||    %d,   %d\n", L[i], U[i])
    end
    println("||")
    println("===============================")
    
end



function feasible(solution, m, L, U)
    # Verifica se a solução é factível
    if sum(solution) != m
        return false
    end
    for i in 1:length(solution)
        if solution[i] < L[i] || solution[i] > U[i]
            return false
        end
    end
    return true
end

########## Calcula valor total de uma solucao ###############

function solution_value(solution)

    v = 0
    for bin in solution
        v += bin_value(bin)
    end
    return v
end


########## Calcula valor de uma bin ###############

function bin_value(x)
    return (x * (x + 1))/2
end
########## Calcula potincial para bin unica ###############

function bin_potential(n, upper)
    return bin_value(upper) - bin_value(n)
end



########## Gera lista de potenciais para solucao gulosa ###############

function calculate_potential(solution, U)

    potential_list = bin_potential.(solution, U)

    return potential_list
end

########## Gera solucao randomizada gulosa ###############
function randomized_greedy_solution(n, m, L, U, n_candidates)
    solution = copy(L)  # Creates a solution list of bins filled to the lower bounds.
    remaining = m - sum(solution)

    indices = fill(0, n)


    # While we have balls, we create a list of the best bins to fill*, then select one of them at random.
    while remaining > 0
        potential = calculate_potential(solution, U)
        partialsortperm!(indices, potential, n_candidates; rev=true) #Find n best bins by potential
        selected = rand(indices)
        change = min((U[selected] - solution[selected]), remaining)
        solution[selected] += change
        remaining -= change
    end

    #print(solution)

    return solution
end

########## Busca Local ##########

function local_search!(solution, n, m, L, U, iter)

    value = solution_value(solution)
    #@printf("value = %d \n", value)

    best_diff = 0

    for i in 1:iter

        best_diff = 0
        best_src = -1
        best_tgt = -1
        best_change = 0

        for s in 1:n
            for t in 1:n
                if s != t 
                    change = min(solution[s] - L[s], U[t] - solution[t])
                    if change > 0  
                        #@printf("s = %d, t = %d \n", solution[s], solution[t])
                        target_increase = bin_value(solution[t] + change)  - bin_value(solution[t])
                        source_decrease = bin_value(solution[s])  - bin_value(solution[s] - change)
                        #@printf("inc = %d, dec = %d \n", target_increase, source_decrease)
                        value_diff = target_increase - source_decrease
                        #@printf("profit = %d \n", value_diff)
                        if value_diff > best_diff
                            best_diff = value_diff
                            best_src = s
                            best_tgt = t
                            best_change = change
                        end
                    end
                end    
            end
        end


        # Ends local search if local maximum found
        if best_diff == 0
            break
        end

        
        #@printf("value = %d \n", value)
        if best_change > 0
            solution[best_src] -= best_change
            solution[best_tgt] += best_change
            value += best_diff

        end

        
        value = solution_value(solution)
        #@printf("new value = %d \n", value)

    end


    #println(feasible(solution, m, L, U))

    #if best_diff == 0
    #    println("Local search found local maximum")
    #else
    #    println("Local search ran out of iterations")
    #end
    
    return value
end


#################### GRASP ########################

function GRASP(n, m, L, U; max_iterations=1000, alpha=0.1, time_limit=Inf, seed=1234)
    Random.seed!(seed)
    start_time = time()
    best_solution = nothing
    best_val = -Inf
    terminated_by_time = false

    for iter in 1:max_iterations
        if time() - start_time > time_limit
            # se passamos do limite de tempo, parar
            terminated_by_time = true
            break
        end


        # Gera solucao gulosa
        solution = randomized_greedy_solution(n, m, L, U, 3)
        val = local_search!(solution, n, m, L, U, 500)

        if !feasible(solution, m, L, U)
            continue
        end

        # Verifica se é a melhor solucao
        if val > best_val
            best_val = val
            best_solution = copy(solution)
            elapsed = time() - start_time
            @printf("%.2f %d %s\n", elapsed, best_val, string(best_solution))
        end

    end

    if terminated_by_time
        println("Encerrado por limite de tempo.")
    else
        println("Encerrado por número máximo de iterações.")
    end

    return best_solution, best_val, time() - start_time
end




########## Programa Principal ##########

if length(ARGS) < 4
    println("Uso: julia grasp_opt.jl <arquivo_instancia> <seed> <max_iterations> <time_limit(segundos)>")
    exit(1)
end

filename = ARGS[1]
seed = parse(Int, ARGS[2])
max_iters = parse(Int, ARGS[3])
time_lim = parse(Float64, ARGS[4])

n, m, L, U = read_instance(filename)

print_problem(n, m, L, U)

solution = randomized_greedy_solution(n, m, L, U, 3)
local_search!(solution, n, m, L, U, 300)

println("END PROGRAM")

best_solution, best_val, total_time = GRASP(n, m, L, U; max_iterations=max_iters, alpha=0.1, time_limit=time_lim, seed=seed)

#print_solution(best_solution, m, L, U)

if best_solution === nothing
    println("Não encontrou solução viável.")
else
    @printf("Melhor solução final: %s\n", string(best_solution))
    @printf("Valor: %d\n", best_val)
    @printf("Tempo total: %.2f s\n", total_time)
end