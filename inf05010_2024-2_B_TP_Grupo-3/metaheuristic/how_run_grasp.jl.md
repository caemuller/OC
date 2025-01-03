## Como rodar o programa em Julia:

#### Testes automatizados:

* Desenvolvemos um script que roda todas as instãncias e salva os resultados em um CSV, visite[ /test/how_run_tests.md](../tests/how_run_tests.md) para mais informações.

---

#### Pré-requisitos

1. **Julia**: Certifique-se de ter o Julia instalado. Você pode baixá-lo em [https://julialang.org/](https://julialang.org/).
2. **Dependências**: Instale os pacotes necessários executando os comandos abaixo no REPL do Julia:

   ```julia
   using Pkg
   Pkg.add("JuMP")
   Pkg.add("HiGHS")
   Pkg.add("Printf")
   ```

#### Formato do Arquivo de Entrada

O programa espera um arquivo de entrada com o seguinte formato:

1. Primeira linha: Número de variáveis \($n$\).
2. Segunda linha: Soma total de bolas \($m$).
3. Próximas \($n$\) linhas: Dois valores \($l_i$\) (limite inferior) e \($u_i$\) (limite superior) separados por espaço.

**Exemplo de arquivo de entrada (`input.txt`):**

> 3
> 10
> 1 5
> 2 4
> 1 3

#### Uso

1. Salve o código em um arquivo chamado `grasp.jl`.
2. Para rodar o programa, use o seguinte comando no terminal:

   ```bash
   julia grasp.jl <arquivo_instancia> <seed> <time_limit(segundos)> <max_iterations> 
   ```

   - `<arquivo_entrada>`: Caminho para o arquivo contendo os dados do problema.
   - `<seed>`: Semente para o gerador de números aleatórios (um número inteiro).
   - `<time_limit>`: Limite de tempo em segundos para resolver o problema (um número de ponto flutuante).
   - `<max_iterations>`: numero maximo de iterações que o programam pode fazer  (um número inteiro).
   - `OBS`: As instancias do problema estão na pasta instances, para chama-las basta usar `../instances/<numero.txt>`

**Exemplo de execução:**

```bash
julia grasp.jl ../instances/input.txt 42 60.0 1000
```

#### Saída

O programa exibirá informações sobre o problema e a solução encontrada:

* **Status** : Estado final da solução.
* **Melhor valor encontrado** : Valor da função objetivo na melhor solução.
* **Bound** : Limite calculado pelo solver.
* **Solução** : Valores das variáveis $x_i$.
* **Tempo decorrido** : Tempo total de execução em segundos.

**Exemplo de saída:**

```
Status: max_iterations
Valor: 25
Tempo total: 13.27
Número de iterações: 1000
Melhor solução final: [3, 4, 3]
```
