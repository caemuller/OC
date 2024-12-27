# Relatório de Entrega

#### Alunos:

- **Caetano Müller - 00333371**
- **Marcos L. K. Reckers - 00315653**
- **Miguel Lemmertz Schwarzbold - 00342191**

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

Observando que $x_i$ é o valor do lucro do $bin_i$ :

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
   Se o recipiente $i$ tem pelo menos $k$ bolas $(y_{i,k} = 1)$, então também tem pelo menos $k-1$ bolas $(y_{i,k-1} =1)$. Isso garante a coerência da contagem incremental:

   $$
   y_{i,k} \le y_{i,k-1} \quad  \begin{cases}
   \forall i \in [n]\\
   \forall k  =2 ,\dots,u_i.
   \end{cases}
   $$
2. **Limites mínimo e máximo:**

   Cada recipiente $i$ deve ter um número de bolas entre $l_{i}$ e $u_{i}$.
   Como:

   $$
   \sum_{k=1}^{u_i} y_{i,k} = x_i
   $$

   Temos:

   $$
   l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i \quad \forall i \in [n]
   $$
3. **Quantidade total de bolas:**
   A soma total de bolas distribuídas entre os recipientes deve ser igual a uma quantidade total $m$:

   $$
   \sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m
   $$
4. **Domínio das variáveis:**

   $$
   y_{i,k} \in \{0,1\} \quad  \begin{cases}
   \forall i \in [n]. \\
   \forall k =1,\dots,u_i.
   \end{cases}
   $$

   $$
   x_{i} \in \Z^+ \quad \forall i = 1, \dots, n.
   $$

### **Modelo Final:**

$$
\max \sum_{i=1}^{n} \sum_{k=1}^{u_i} k \cdot y_{i,k}
$$

Sujeito a:

$$
y_{i,k} \le y_{i,k-1}  \quad  \begin{cases}
\forall i \in [n] \\
\forall k=2,\dots,u_i.
\end{cases}
$$

$$
l_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i  \quad  \forall i \in [n]
$$

$$
\sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m
$$

$$
y_{i,k} \in \{0,1\}  \quad  \begin{cases}
\forall i \in [n] \\
\forall k =1,\dots,u_i.
\end{cases}
$$

### Testes:

* 01.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 02.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 03.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 04.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 05.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 06.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 07.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 08.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 09.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
* 10.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    |                  |       |                        |
