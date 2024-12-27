using CSV
using DataFrames
using Dates

include("Linear.jl")
include("GRASP.jl")

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

path = "C:/Users/marco/Documents/dev/otimizacao/inf05010_2024-2_B_TP_Grupo-3/"
test_files = [path*"01.txt", path*"02.txt", path*"03.txt", path*"04.txt", path*"05.txt", path*"06.txt", path*"07.txt", path*"08.txt", path*"09.txt", path*"10.txt"]

# Parâmetros de teste
seed = 6
time_limit = 300.0  
max_iterations = 1000

#run_linear_on_files(test_files, seed, time_limit)
run_grasp_on_files(test_files, seed, time_limit, max_iterations)