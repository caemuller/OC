# Relatório de Entrega

#### Alunos:

- Caetano Müller - 00333371
- Marcos L. K. Reckers - 00315653
- Miguel

## Formulação Inteira:

#### **Variáveis de decisão:**

Para cada recipiente $ i \in \{1, \dots , n\}$ e para cada valor inteiro $ k \in \{1,\dots,u_i\}$, definimos uma variável binária:

$$
y_{i,k} = \begin{cases}
1 & \text{se } x_i \ge k \\
0 & \text{caso contrário}
\end{cases}
$$

Esse valor $x_i$ representa que no recipiente $i$ temos pelo menos a altura $k$.

#### **Função Objetivo:**

A função objetivo original é maximizar:

$$
\sum_{i=1}^{n} x_i \frac{(x_i+1)}{2}.
$$

Observando que:

$$
x_i = \sum_{k=1}^{u_i} y_{i,k}
$$

e o lucro correspondente pode ser reescrito como:

$$
\sum_{k=1}^{u_i} k \cdot y_{i,k},
$$

a função objetivo linearizada é:

$$
\max \sum_{i=1}^{n} \sum_{k=1}^{u_i} k \cdot y_{i,k}.
$$

### **Restrições:**

1. **Monotonicidade:**
   Se o recipiente $i$ tem pelo menos $k$ bolasa $(y_{i,k} = 1)$, então também tem pelo menos $k-1$ bolas $(y_{i,k-1} =1)$. Isso garante a coerência da contagem incremental:

   $$
   y_{i,k} \le y_{i,k-1} \quad  \begin{cases}
   \forall i & =1 ,\dots, n. \\
   \forall k & =2 ,\dots,u_i.
   \end{cases}
   $$
2. **Limites mínimo e máximo:**

   Cada recipiente $i$ deve ter um número de bolas entre $l_{i}$e $u_{i}$. Como: $\sum_{k=1}^{u_i} y_{i,k} = x_i $, temos:

   $$
   l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i \quad  \begin{cases}
   \forall i & =1 ,\dots, n. \\
   \forall k & =1,\dots,u_i.
   \end{cases}
   $$
3. **Quantidade total de bolas:**
   A soma total de bolas distribuídas entre os recipientes deve ser igual a uma quantidade total $m$:

   $$
   \sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m  \quad  \begin{cases}
   \forall i & =1 ,\dots, n. \\
   \forall k & =1,\dots,u_i.
   \end{cases}
   $$
4. **Domínio das variáveis:**

   $$
   y_{i,k} \in \{0,1\} \quad  \begin{cases}
   \forall i & =1 ,\dots, n. \\
   \forall k & =1,\dots,u_i.
   \end{cases}
   $$

   $$
   x_{i} \in \Z \quad \forall i = 1, \dots, n.
   $$

### **Modelo Final:**

$$
\max \sum_{i=1}^{n} \sum_{k=1}^{u_i} k \cdot y_{i,k}
$$

Sujeito a:

$$
y_{i,k} \le y_{i,k-1}  \quad  \begin{cases}
\forall i & =1 ,\dots, n. \\
\forall k & =2,\dots,u_i.
\end{cases}
$$

$$
l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i  \quad  \begin{cases}
\forall i & =1 ,\dots, n. \\
\forall k & =1,\dots,u_i.
\end{cases}
$$

$$
\sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m  \quad  \begin{cases}
\forall i & =1 ,\dots, n. \\
\forall k & =1,\dots,u_i.
\end{cases}
$$

$$
y_{i,k} \in \{0,1\}  \quad  \begin{cases}
\forall i & =1 ,\dots, n. \\
\forall k & =1,\dots,u_i.
\end{cases}
$$

## Como rodar o programa em Julia:

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

1. Primeira linha: Número de variáveis \(n\).
2. Segunda linha: Soma total de bolas \(m\).
3. Próximas \(n\) linhas: Dois valores \(l_i\) (limite inferior) e \(u_i\) (limite superior) separados por espaço.

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

## Meta-Heuristica: GRASP
