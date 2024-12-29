
include("grasp_opt.jl")

if length(ARGS) < 5
    println("Uso: julia grasp_opt.jl <arquivo_instancia> <seed> <max_iterations> <time_limit(segundos)> <n_candidatos>")
    exit(1)
end

filename = ARGS[1]
seed = parse(Int, ARGS[2])
max_iterations = parse(Int, ARGS[3])
time_limit = parse(Float64, ARGS[4])
n_candidates = parse(Int, ARGS[5])
GRASP(filename, max_iterations, time_limit, seed, n_candidates)