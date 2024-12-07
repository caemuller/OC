# Relatório de Entrega


Formulação Inteira

**Ideia da Modelagem Linear:**

O problema original é escolher xix_i (número de bolas no recipiente i) com li≤xi≤uil_i \le x_i \le u_i e ∑ixi=m\sum_i x_i = m, maximizando ∑ixi(xi+1)2\sum_i \frac{x_i(x_i+1)}{2}. Como essa função objetivo é não-linear, precisamos linearizá-la.

**Linearização:**

Podemos usar variáveis binárias auxiliares. Definimos:

* Variáveis binárias yi,k∈{0,1}y_{i,k} \in \{0,1\} para cada recipiente i e para cada k em [1,ui][1, u_i] para indicar se o recipiente i tem pelo menos k bolas.

Assim:

* Se yi,k=1y_{i,k} = 1, significa que xi≥kx_i \ge k.
* A contagem de bolas em i, xi=∑k=1uiyi,kx_i = \sum_{k=1}^{u_i} y_{i,k}.
* O lucro em i é ∑k=1uik⋅yi,k\sum_{k=1}^{u_i} k \cdot y_{i,k}, pois se o recipiente tem ao menos k bolas, é adicionado o valor k ao seu lucro.

**Restrições:**

1. **Monotonicidade** : se yi,k=1y_{i,k} = 1, então yi,k−1y_{i,k-1} também deve ser 1. Isso garante a coerência da contagem.

   yi,k≤yi,k−1∀i,k=2,…,uiy_{i,k} \le y_{i,k-1} \quad \forall i, k=2,\dots,u_i

1. **Limites mínimo e máximo** :

   li≤∑k=1uiyi,k≤ui∀il_i \le \sum_{k=1}^{u_i} y_{i,k} \le u_i \quad \forall i

1. **Soma total de bolas** :

   ∑i=1n∑k=1uiyi,k=m\sum_{i=1}^{n} \sum_{k=1}^{u_i} y_{i,k} = m

1. **Domínio** :

   yi,k∈{0,1}y_{i,k} \in \{0,1\}

 **Função Objetivo** :

Maximizar

∑i=1n∑k=1uik⋅yi,k\sum_^ \sum_^ k \cdot y_
--------------------------------------------
