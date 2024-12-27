## Como rodar o programa em Julia:

#### Pré-requisitos

1. **Julia**: Certifique-se de ter o Julia instalado. Você pode baixá-lo em [https://julialang.org/](https://julialang.org/).
2. **Dependências**: Instale os pacotes necessários executando os comandos abaixo no REPL do Julia:

   ```julia
   using Pkg
   Pkg.add("JuMP")
   Pkg.add("HiGHS")
   Pkg.add()
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

1. Salve o código em um arquivo chamado `linear.jl`.
2. Para rodar o programa, use o seguinte comando no terminal:

   ```bash
   julia linear.jl <arquivo_entrada> <seed> <time_limit>
   ```

   - `<arquivo_entrada>`: Caminho para o arquivo contendo os dados do problema.
   - `<seed>`: Semente para o gerador de números aleatórios (um número inteiro).
   - `<time_limit>`: Limite de tempo em segundos para resolver o problema (um número de ponto flutuante).

**Exemplo de execução:**

```bash
julia linear.jl input.txt 42 60.0
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
Status: OPTIMAL
Melhor valor encontrado: 25.00
Bound: 25.00
Solução: [3, 4, 3]
Tempo decorrido: 12.34
```