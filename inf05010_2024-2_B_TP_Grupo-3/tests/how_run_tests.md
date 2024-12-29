# Instruções para Rodar o Código em Julia

Este repositório contém a implementação de algoritmos GRASP (metaheurísticas e versão otimizada) e solução linear para resolução de problemas de otimização. A seguir, apresentamos as instruções para execução.

---

## Pré-requisitos

1. **Julia**: Certifique-se de ter o Julia instalado. Você pode baixá-lo em [https://julialang.org/](https://julialang.org/).
2. **Dependências**: Instale os pacotes necessários executando os comandos abaixo no REPL do Julia:

   ```julia
   using Pkg
   Pkg.add("JuMP")
   Pkg.add("HiGHS")
   ```
3. **Estrutura das Pastas**: Tenha certeza que os códigos dos GRASP e da formulação linear estão nas pastas corretas:

   ```julia
    include("../formulation/Linear.jl")
    include("../metaheuristic/grasp_opt.jl")
    include("../metaheuristic/grasp.jl")
   ```

---

## Como rodar os testes

### Testes Automatizados:

O script `run_tests.jl` executa as instâncias definidas e salva os resultados em arquivos CSV.

Para editar as instâncias mude diretamente dentro da main() do arquivo `run_tests.jl:`

```julia
function main()
    if length(ARGS) < 2
        println("Uso: julia run_tests.jl <seed> <max_iterations>")
        exit(1)
    end
  
    seed = parse(Int, ARGS[1])
    max_iterations = parse(Int, ARGS[2])
  
    #run_grasp_on_files(<test_files>, <seed>, <time>, <max_iterations>)
    #run_grasp_optimized_on_files(<test_files>, <seed>, <time>, <max_iterations>, <n_candidates>)
    #run_linear_on_files(<test_files>, <seed>, <time>)

    run_grasp_on_files(test_files, seed, 5.0, max_iterations)
    run_grasp_on_files(test_files, seed, 300.0, max_iterations)
    run_grasp_optimized_on_files(test_files, seed, 5.0, max_iterations, 8)
    run_grasp_optimized_on_files(test_files, seed, 300.0, max_iterations, 8)
    run_linear_on_files(test_files, seed, 5.0)
    run_linear_on_files(test_files, seed, 300.0)
    run_linear_on_files(test_files, seed, 3600.0)
end
```

#### Formato do Arquivo de Entrada

Os arquivos de entrada devem estar na pasta `../instances/` e seguir o formato esperado pelo programa:

1. Primeira linha: Número de variáveis **$n$**.
2. Segunda linha: Soma total de bolas ($m$).
3. Próximas **$n$** linhas: Dois valores **$l_i$** (limite inferior) e **$u_i$** (limite superior) separados por espaço.

**Exemplo de arquivo de entrada (`input.txt`):**

```txt
3
10
1 5
2 4
1 3
```

---

### Execução do Script

1. **Salve o código** : Certifique-se de que o código `run_tests.jl` está no diretório correto.
2. **Chamada do Script** : Execute o script passando os parâmetros necessários:

```bash
julia run_tests.jl <seed> <max_iterations>
```

* `<seed>`: Número inteiro para inicializar o gerador de números aleatórios.
* `<max_iterations>`: Número máximo de iterações permitido nos algoritmos GRASP.

**Exemplo:**

```bash
julia run_tests.jl 42 1000
```

---

### Estrutura dos Resultados

Os resultados de cada execução são salvos em arquivos CSV na mesma pasta do script. Cada arquivo contém as seguintes colunas:

* **filename** : Nome do arquivo de instância processado.
* **type** : Tipo de algoritmo utilizado (`grasp`, `grasp_optimized`, ou `linear`).
* **status** : Status final do algoritmo.
* **best_value** : Melhor valor encontrado para a solução.
* **time** : Tempo total de execução (em segundos).
* **time_limit** : Limite de tempo configurado (em segundos).
* **seed** : Semente utilizada.
* **max_iterations** : Número máximo de iterações permitido.
* **num_iterations** : Número de iterações realizadas.
* **best_solution** : Melhor solução encontrada.
* **bound** : Limite calculado (apenas para soluções lineares).

---

## Observações

1. **Alterações no Script** :

* Caso deseje rodar apenas uma das funções (ex.: GRASP ou solução linear), descomente a chamada correspondente no `main()`.

1. **Erros de Execução** :

* Certifique-se de que os arquivos de instância estejam no formato correto e na pasta `../instances/`.
* Verifique se as dependências foram instaladas corretamente.

---
