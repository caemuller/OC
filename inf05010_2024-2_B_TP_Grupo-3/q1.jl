# Para tornar mais rápida a execução:
# * Executar os comandos antes de `m = Model(...)` em um terminal,
#   comentar o `main()` no final do arquivo. Então executar
#   `Revise.includet("q1.jl")`, daí se pode só editar o arquivo e chamar
#   `main()` para executar novamente.
import Pkg
Pkg.add("Revise");
Pkg.activate(@__DIR__)
Pkg.instantiate()

using JuMP
using HiGHS

function main()
    m = Model(HiGHS.Optimizer)

	# formulation here
    n = parse(Int, ARGS[1])

    # potências de dois até 2048
    potencias = [2^i for i in 0:11]  
	
    # Define as variáveis binárias para cada potência de dois
    @variable(m, x[1:length(potencias)], Bin)

    # Adiciona a restrição de que a soma das potências escolhidas deve ser igual a n
    @constraint(m, sum(x[i] * potencias[i] for i in 1:length(potencias)) == n)

    # Define a função objetivo: minimizar o número de potências usadas
    @objective(m, Min, sum(x[i] for i in 1:length(potencias)))

    optimize!(m)
    @show objective_value(m)
    # @show value(single_var)
    # @show value.(vector of variables)
end

main() # comentar aqui se for executar no terminal Julia


