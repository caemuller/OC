include("../formulation/Linear.jl")
include("../metaheuristic/grasp.jl")

function save_results(csv_name, filename, type, status, best_value, time, time_limit, seed, max_iterations, num_iterations, best_solution, bound=0)
    if !isfile(csv_name)
        open(csv_name, "w") do io
            println(io, "filename,type,status,best_value,time,time_limit,seed,max_iterations,num_iterations,best_solution,bound")
        end
    end
    open(csv_name, "a") do io
        println(io, "$filename,$type,$status,$best_value,$time,$time_limit,$seed,$max_iterations,$num_iterations,$best_solution,$bound")
    end
end

function run_grasp_on_files(test_files::Vector{String}, seed::Int, time_limit::Float64, max_iterations::Int)
    for filename in test_files
        try
            status, best_value, time, num_iterations, best_solution = grasp(filename, max_iterations, time_limit, seed)
            filename = split(filename, "/")[end]
            csv_name = "resultados_"* "grasp_" * string(time_limit) * "s_" * string(max_iterations) * "i_.csv"
            time = round(time, digits=2)
            save_results(csv_name, filename, "grasp", status, best_value, time, time_limit, seed, max_iterations, num_iterations, best_solution, 0)
        catch e
            println("Erro ao processar o arquivo $filename: ", e)
        end
    end
    
end

function run_linear_on_files(test_files::Vector{String}, seed::Int, time_limit::Float64)
    for filename in test_files
        try
            best_solution, best_value, solve_time, num_iterations, status, bound = solve_integer_problem(filename, seed, time_limit)
            filename = split(filename, "/")[end]
            csv_name = "resultados_"* "linear_" * string(time_limit) * "s_.csv"
            solve_time = round(solve_time, digits=2)
            best_value = replace(string(best_value), "." => "")
            save_results(csv_name, filename, "linear", status, best_value, solve_time, time_limit, seed, 0, num_iterations, best_solution, bound)
        catch e
            println("Erro ao processar o arquivo $filename: ", e)
        end
    end
end

#-------------------------------------------------------------------------------------------------------------------------------------------
### Parâmetros de teste ###
instances_path = "C:/Users/marco/Documents/dev/otimizacao/inf05010_2024-2_B_TP_Grupo-3/instances/"

test_files = [instances_path*"01.txt", instances_path*"02.txt", instances_path*"03.txt", instances_path*"04.txt", instances_path*"05.txt", instances_path*"06.txt", instances_path*"07.txt", instances_path*"08.txt", instances_path*"09.txt", instances_path*"10.txt"]

seed = 6 

max_iterations = 1000
#-------------------------------------------------------------------------------------------------------------------------------------------

run_grasp_on_files(test_files, seed, 5.0, max_iterations)
run_grasp_on_files(test_files, seed, 300.0, max_iterations)
run_linear_on_files(test_files, seed, 5.0)
run_linear_on_files(test_files, seed, 300.0)
run_linear_on_files(test_files, seed, 3600.0)