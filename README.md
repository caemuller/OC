# Relatório de Entrega

#### Alunos:

- Caetano
- Marcos L. K. Reckers - 00315653
- Miguel

### Formulação Inteira:

**Variáveis de decisão:**

Para cada recipiente $ i \in \{1, \dots , n\}$ e para cada valor inteiro $ k \in \{1,\dots,u_i\}$, definimos uma variável binária:

$$
y_{i,k} = \begin{cases}
1 & \text{se } x_i \ge k \\
0 & \text{caso contrário}
\end{cases}
$$

**Função Objetivo:**

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

**Restrições:**

1. **Monotonicidade:**
   Se o recipiente $i$ tem pelo menos $k$ bolasa $(y_{i,k} = 1)$, então também tem pelo menos $k-1$ bolas $(y_{i,k-1} =1)$. Isso garante a coerência da contagem incremental:

   $$
   y_{i,k} \le y_{i,k-1} \quad \forall i, \; \forall k=2,\dots,u_i.
   $$
2. **Limites mínimo e máximo:**

   Cada recipiente $i$ deve ter um número de bolas entre $l_{i}$e $u_{i}$. Como: $\sum_{k=1}^{u_i} y_{i,k} = x_i $, temos:

   $$
   l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i \quad \forall i.
   $$
3. **Quantidade total de bolas:**
4. **Domínio das variáveis:**

   $$
   y_{i,k} \in \{0,1\} \quad \forall i, \; \forall k=1,\dots,u_i.
   $$

**Modelo Final:**

$$
\max \sum_{i=1}^{n} \sum_{k=1}^{u_i} k \cdot y_{i,k}
$$

Sujeito a:

$$
y_{i,k} \le y_{i,k-1} \quad \forall i, \; \forall k=2,\dots,u_i
$$

$$
l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i \quad \forall i
$$

$$
\sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m
$$

$$
y_{i,k} \in \{0,1\} \quad \forall i, \; \forall k=1,\dots,u_i
$$
