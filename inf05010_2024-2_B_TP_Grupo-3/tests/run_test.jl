include("../formulation/Linear.jl")
include("../metaheuristic/dumb_grasp.jl")

function run_grasp_on_files(test_files::Vector{String}, seed::Int, time_limit::Float64, max_iterations::Int)
    for filename in test_files
        try
            grasp(filename, max_iterations, time_limit, seed)
        catch e
            println("Erro ao processar o arquivo $filename: ", e)
        end
    end
    
end

function run_linear_on_files(test_files::Vector{String}, seed::Int, time_limit::Float64)
    for filename in test_files
        try
            solve_integer_problem(filename, seed, time_limit)
        catch e
            println("Erro ao processar o arquivo $filename: ", e)
        end
    end
end

path = "C:/Users/marco/Documents/dev/otimizacao/inf05010_2024-2_B_TP_Grupo-3/instances/"
test_files = [path*"01.txt", path*"02.txt", path*"03.txt", path*"04.txt", path*"05.txt", path*"06.txt", path*"07.txt", path*"08.txt", path*"09.txt", path*"10.txt"]

# Parâmetros de teste
seed = 6
time_limit = 5.0  
max_iterations = 1000

#run_linear_on_files(test_files, seed, time_limit)
grasp(test_files[1], max_iterations, time_limit, seed)
grasp(test_files[2], max_iterations, time_limit, seed)
grasp(test_files[3], max_iterations, time_limit, seed)
grasp(test_files[4], max_iterations, time_limit, seed)
grasp(test_files[5], max_iterations, time_limit, seed)
grasp(test_files[6], max_iterations, time_limit, seed)
grasp(test_files[7], max_iterations, time_limit, seed)
grasp(test_files[8], max_iterations, time_limit, seed)
grasp(test_files[9], max_iterations, time_limit, seed)
grasp(test_files[10], max_iterations, time_limit, seed)