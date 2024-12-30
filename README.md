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
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 1034999          | 16,72s | 15824                  |
* 02.txt
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 11984785         | 95,77s | 59662                  |
* 03.txt
  * | Melhor solução | Tempo    | Numero de interações |
    | ---------------- | -------- | ---------------------- |
    | 45979231         | 1160,79s | 247322                 |
* 04.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 34178023         | 576,88s | 125500                 |
* 05.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 8202061          | 434.74s | 125566                 |
* 06.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 29749789         | 980.97s | 241060                 |
* 07.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 206913418        | 2110.8s | 241666                 |
* 08.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 42668196         | 328.68s | 119416                 |
* 09.txt
  * | Melhor solução | Tempo   | Numero de interações |
    | ---------------- | ------- | ---------------------- |
    | 8461953          | 248.43s | 124426                 |
* 10.txt
  * | Melhor solução | Tempo    | Numero de interações |
    | ---------------- | -------- | ---------------------- |
    | 48352227         | 1294.38s | 242316                 |

## Metaheurística

### GRASP - Greedy Randomized Adaptive Search Procedure

O algoritmo GRASP pode ser definido em duas etapas:

* Geração da solução gulosa
* Busca local
  
Essas etapas são repetidas, mantendo salva a melhor solução encontrada até o momento, durante o tempo limite de execução. Nossa implementação em Julia do algoritmo utilisa destas etapas para encontrar soluções próximas à ótima no problema Bins and Balls com limites de tempo e iterações restritos.

#### 1. Geração da solução gulosa

   A solução gulosa é gerada inserindo as bolas nas bins mais promissoras até que não sobrem mais bolas não posicionadas.
   Inicialmente, bolas são inseridas nas bins para atingir os limites inferiores.
   Após isso, um laço é excecutado enquanto existem bolas livres:
   |   O potencial de cada bin é calculado. O potencial é definido como a mudança na pontuação caso o bin fosse preenchido com bolas.
   |   São selecionados os N bins candidatos com maior potencial. Na nossa implementação, N foi empiricamente definido como 8
   |   Um bin aleatório dentre os candidatos é selecionado e preenchido com bolas. Caso não haja bolas suficientes, é enchido com todas as bolas restantes
   |   O novo número de bolas é atualizado.
   Ao fim do laço temos uma solução gulosa válida

   Outras ideias foram testadas para a geração da solução gulosa, incluindo posicionar cada bola individualmente. Esta idea foi testada e é funcional, mas pode ser lenta.
   Outra ideia possível seria testar a "densidade" do pontencial, isto é, ordenar as bins por quanto elas iriam aumentar a pontuação por bolinha.

#### 2. Busca local

   A busca local é feita gerando todos os vizinhos de uma solução, e escolhendo o que representa o maior aumento na função objetivo.
   O conceito de vizinhança utilizado é baseado na mudança máxima entre duas Bins distintas, isto é, para cada par direcionado de bins existe uma solução vizinha gerada movendo o maior número de balls do primeiro bin para o segundo. Esta vizinhança foi escolhida por sua eficiência, pois permite mover quantidades grandes de bolas por iteração da busca local.
   Foi implementada e testada a vizinhança baseada na mudança de uma única bola. Esta lógica permite algoritmos eficientes para achar o melhor vizinho, mas torna o algoritmo de busca local muito mais ineficiente, necessitando de mais iterações para encontrar algum ótimo local. Por estes motivos, esta opção foi desconsiderada.

   Encontrado o melhor vizinho, caso exista, a nova solução é gerada e o valor armazenado da solução é atualizado com base na mudança das bolas, sem necessitar o cálculo completo do valor de cada bin.
   Caso a solução já seja ótimo local, ou caso o número limite de iterações para a busca local (500, na nossa implementação) seja atingido, o valor atual é retornado, junto com a configuração de bolas encontrada.

Após o fim das iterações ou ao atingir o limite de tempo o algoritmo retorna a melhor solução encontrada, assim como dados de tempo de execução, número de iterações e valor da solução encontrada.

O algoritmo GRASP funciona especificamente bem com limites de tempo restritos, pois a solução gulosa, optimizada com a busca local, gera valores relativamente próximos à valores gerados com limites de tempo muitas ordens de grandeza maiores.

### Testes com duração de 5 segundos:

* 01.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 1034418          | 5.0   | 984                    |
* 02.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 11976398         | 4.56  | 1000                   |
* 03.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 45898177         | 5.0   | 479                    |
* 04.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 34169225         | 5.01  | 509                    |
* 05.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 8196666          | 5.01  | 34                     |
* 06.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 29732090         | 5.22  | 23                     |
* 07.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 206796746        | 4.61  | 1000                   |
* 08.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 42627558         | 4.54  | 1000                   |
* 09.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 8443590          | 5.01  | 103                    |
* 10.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 48326460         | 5.04  | 89                     |

### Testes com duração de 300 segundos:

* 01.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 1034809          | 300.0 | 64821                  |
* 02.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 11983213         | 300.0 | 65442                  |
* 03.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 45898177         | 300.0 | 30548                  |
* 04.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 34172895         | 300.0 | 28860                  |
* 05.txt
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 8197571          | 300.04 | 2007                   |
* 06.txt
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 29737000         | 300.01 | 1358                   |
* 07.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 206863654        | 300.0 | 62964                  |
* 08.txt
  * | Melhor solução | Tempo | Numero de interações |
    | ---------------- | ----- | ---------------------- |
    | 42644514         | 300.0 | 64543                  |
* 09.txt
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 8450559          | 300.01 | 6329                   |
* 10.txt
  * | Melhor solução | Tempo  | Numero de interações |
    | ---------------- | ------ | ---------------------- |
    | 48332953         | 300.02 | 5398                   |

## Conclusões Finais:

    Os resultados deste trabalho evidenciam que o GRASP, tanto em sua versão inicial quanto otimizada, é uma abordagem eficiente para resolver o problema apresentado, especialmente em cenários onde o tempo de execução é restrito. Em muitos casos, o GRASP conseguiu encontrar soluções tão boas quanto as obtidas pela formulação linear, mas em uma fração do tempo necessário para o método exato. Mesmo nos casos em que as soluções não foram ótimas, elas se aproximaram significativamente do ótimo, o que demonstra a eficácia da estratégia gulosa-randômica combinada com busca local.

    A formulação linear, por outro lado, é fundamental para garantir a obtenção de soluções ótimas globais, validando a qualidade das soluções obtidas pelas metaheurísticas. Entretanto, ela apresenta limitações em termos de tempo de execução, especialmente para instâncias maiores ou mais complexas. Essa diferença é explicada pelo fato de que a formulação linear utiliza métodos exatos, que exploram todo o espaço de soluções viáveis, enquanto o GRASP prioriza rapidez e heurísticas eficientes para explorar apenas uma parte do espaço.

    Entre as versões do GRASP, o algoritmo otimizado se destacou por utilizar uma lista de candidatos restrita e um melhor balanceamento entre exploração e intensificação, permitindo encontrar soluções de alta qualidade mais rapidamente em comparação ao GRASP inicial. Essas diferenças tornam o GRASP otimizado uma alternativa atraente para cenários práticos, onde há necessidade de soluções rápidas e boas, enquanto a formulação linear se posiciona como um método de referência para análises mais detalhadas e obtenção de soluções ótimas.
