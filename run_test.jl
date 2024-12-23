using CSV
using DataFrames
using Dates

function test_and_log_results(func::Function, test_cases::Vector, output_file::String)
    results = DataFrame(Function = String[], TestIndex = Int[], ReturnValue = Any[], ExecutionTime = Float64[])
    
    for (i, test) in enumerate(test_cases)
        start_time = time()
        try
            return_value = func(test...)
            exec_time = time() - start_time
            push!(results, (string(func), i, return_value, exec_time))
        catch e
            exec_time = time() - start_time
            push!(results, (string(func), i, string("Error: ", e), exec_time))
        end
    end
    
    
    CSV.write(output_file, results)
    println("Results written to $(output_file)")
end
