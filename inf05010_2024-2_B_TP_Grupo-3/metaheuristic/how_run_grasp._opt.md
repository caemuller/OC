
# Como rodar o código GRASP otimizado em Julia

Este guia explica como executar o código GRASP otimizado descrito, que resolve problemas de otimização relacionados ao modelo "Bins and Balls".

---

## Pré-requisitos

1. **Julia** : Certifique-se de que o Julia está instalado no seu sistema. Baixe-o em [https://julialang.org/](https://julialang.org/).
2. **Dependências** : Este código não depende de bibliotecas externas além das padrões do Julia (`Random`, `Printf`, e `Statistics`).

---

## Formato do Arquivo de Instância

O código espera que os arquivos de entrada estejam no seguinte formato:

1. Primeira linha: Número de recipientes **$n$**.
2. Segunda linha: Número total de bolas **$m$**.
3. Próximas **$n$** linhas: Dois valores inteiros **$l_i$ e $u_i$**, representando os limites inferior e superior de bolas para cada recipiente.

**Exemplo de arquivo de instância (`input.txt`):**

```txt
3
10
1 5
2 4
1 3
```

---

## Como executar o programa

1. Salve o código acima em um arquivo chamado `grasp_opt.jl`.
2. Certifique-se de que os arquivos de instância estão no mesmo diretório ou no caminho correto.
3. Para rodar o programa, use o seguinte comando no terminal:

```bash
julia grasp_opt.jl <arquivo_instancia> <seed> <max_iterations> <time_limit> <n_candidates>
```

### Parâmetros:

* `<arquivo_instancia>`: Caminho para o arquivo contendo os dados do problema.
* `<seed>`: Semente para o gerador de números aleatórios (um número inteiro).
* `<max_iterations>`: Número máximo de iterações permitidas no GRASP.
* `<time_limit>`: Limite de tempo (em segundos) para execução do algoritmo.
* `<n_candidates>`: Número de candidatos considerados na construção gulosa-randômica.

**Exemplo de execução:**

```bash
julia grasp_opt.jl ../instances/01.txt 42 1000 300.0 8
```

---

## Saída do Programa

A saída inclui informações detalhadas sobre a execução do algoritmo:

* **Status** : Motivo pelo qual a execução terminou (tempo limite ou máximo de iterações).
* **Valor** : Valor da melhor solução encontrada.
* **Tempo total** : Tempo total de execução em segundos.
* **Número de iterações** : Quantidade de iterações realizadas.
* **Melhor solução final** : Configuração das bolas em cada recipiente.

**Exemplo de saída:**

```
Solução encontrada em 15.2s, valor: 958
===============================
||       Solução             ||
===============================
|| balls = 10 
|| bins = 3 
||  Lower,   Upper,    Value  
||    1,   5   ->   3
||    2,   4   ->   4
||    1,   3   ->   3
||
===============================
Status: time_limit
Valor: 958
Tempo total: 300.0 s
Número de iterações: 4321
Melhor solução final: [3, 4, 3]
```

---

## Observações

1. **Configurações Experimentais** :

* O número de candidatos (n_candidatesn\_candidates) impacta diretamente na qualidade da solução e no tempo de execução. Experimente ajustar este valor para otimizar resultados.

1. **Erros Comuns** :

* Verifique se o arquivo de entrada segue o formato correto.
* Confirme que os parâmetros passados no terminal estão no formato esperado.

1. **Debugging** :

* O programa imprime informações úteis para análise, como a factibilidade da solução e os potenciais de cada recipiente. Use esses dados para identificar problemas no arquivo de entrada ou nos parâmetros.
