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
    for i in 1:length(x)
        if x[i] < L[i] || x[i] > U[i]
            return false
        end
    end
    return true
end

########## Construção Gulosa-Randômica (GRASP) ##########

function construct_solution(n, m, L, U; alpha=0.1)
    # Passo 1: começar com x_i = L[i]
    x = copy(L)
    bolas_colocadas = sum(L)
    sobra = m - bolas_colocadas

    # Enquanto houver bolas para distribuir
    while sobra > 0
        # Calcular ganhos incrementais
        # Ganho ao adicionar 1 bola em i: (x[i]+1)
        # mas só se x[i] < U[i]
        increment_list = []
        for i in 1:n
            if x[i] < U[i]
                push!(increment_list, (i, x[i]+1))
            end
        end

        if isempty(increment_list)
            # Não há mais onde por bolas, deve estar tudo alocado
            break
        end

        # Ordena por ganho decrescente
        sort!(increment_list, by = t->t[2], rev=true)
        melhor_ganho = increment_list[1][2]
        cutoff = melhor_ganho - alpha*melhor_ganho

        # RCL: recipientes com ganho ≥ cutoff
        RCL = [i_gain[1] for i_gain in increment_list if i_gain[2] >= cutoff]

        escolhido = RCL[rand(1:length(RCL))]

        # Aloca 1 bola no recipiente escolhido
        x[escolhido] += 1
        sobra -= 1
    end

    return x
end

########## Busca Local ##########

function local_search(x, L, U, m; max_no_improve=100)
    best_x = copy(x)
    best_val = solution_value(x)
    no_improve = 0

    # Estratégia simples: tenta mover uma bola de i para j, se factível e melhora
    # Repetir até não melhorar por um número de tentativas
    # (Para não ser muito lento, limitamos o número de iterações)
    improved = true
    while improved && no_improve < max_no_improve
        improved = false
        for i in 1:length(x)
            for j in 1:length(x)
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

function grasp(n, m, L, U; max_iterations=1000, alpha=0.1, time_limit=Inf, seed=1234)
    Random.seed!(seed)
    start_time = time()
    best_x = nothing
    best_val = -Inf
    terminated_by_time = false

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
        x_local = local_search(x, L, U, m; max_no_improve=50)
        val = solution_value(x_local)

        # Se for melhor que o melhor conhecido, imprimir e atualizar
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