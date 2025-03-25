# TRABALHO DE IAA003 – Linguagem R 

## Equipe 03
Gustavo Costa de Souza
Marcos Vinicius de Melo
Marcus Eneas Silveira Galvao do Rio Apa II
Patrícia Verdugo Pascoal
Rodrigo de Araujo
William de Souza Alencar

---
 
Este trabalho deve ser realizado em equipes de 3 até no máximo 6 integrantes. 
Adicionar o NOME COMPLETO de todos os integrantes da equipe. 
O que deve ser entregue: 
1.	Um arquivo compactado (.zip) contendo todos os documentos pertinentes 
2.	Um documento PDF contendo a lista de comandos R que foi executada, com suas respectivas saídas 
3.	Os scripts em R (arquivos .R) que foram executados por vocês 
4.	Um texto com a escolha do melhor modelo em cada exercício e a justificativa do porquê

---

## 1	Pesquisa com Dados de Satélite (Satellite) 
 
O banco de dados consiste nos valores mul2espectrais de pixels em vizinhanças 3x3 em uma imagem de satélite, e na classificação associada ao pixel central em cada vizinhança. O obje2vo é prever esta classificação, dados os valores mul2espectrais. 
 
Um quadro de imagens do Satélite Landsat com MSS (Mul$spectral Scanner System) consiste em quatro imagens digitais da mesma cena em diferentes bandas espectrais. Duas delas estão na região visível (correspondendo aproximadamente às regiões verde e vermelha do espectro visível) e duas no infravermelho (próximo). Cada pixel é uma palavra binária de 8 bits, com 0 correspondendo a preto e 255 a branco. A resolução espacial de um pixel é de cerca de 80m x 80m. Cada imagem contém 2340 x 3380 desses pixels. O banco de dados é uma subárea (minúscula) de uma cena, consis2ndo de 82 x 100 pixels. Cada linha de dados corresponde a uma vizinhança quadrada de pixels 3x3 completamente con2da dentro da subárea 82x100. Cada linha contém os valores de pixel nas quatro bandas espectrais (conver2das em ASCII) de cada um dos 9 pixels na vizinhança de 3x3 e um número indicando o rótulo de classificação do pixel central. 
 
As classes são: solo vermelho, colheita de algodão, solo cinza, solo cinza úmido, restolho de vegetação, solo cinza muito úmido. 
 
Os dados estão em ordem aleatória e certas linhas de dados foram removidas, portanto você não pode reconstruir a imagem original desse conjunto de dados. Em cada linha de dados, os quatro valores espectrais para o pixel superior esquerdo são dados primeiro, seguidos pelos quatro valores espectrais para o pixel superior central e, em seguida, para o pixel superior direito, e assim por diante, com os pixels lidos em sequência, da esquerda para a direita e de cima para baixo. Assim, os quatro valores espectrais para o pixel central são dados pelos atributos 17, 18, 19 e 20. Se você quiser, pode usar apenas esses quatro atributos, ignorando os outros. Isso evita o problema que surge quando uma vizinhança 3x3 atravessa um limite. 
 
O banco de dados se encontra no pacote mlbench e é completo (não possui dados faltantes). 
 
Tarefas: 
1.	Carregue a base de dados Satellite 
2.	Crie par2ções contendo 80% para treino e 20% para teste 
3.	Treine modelos RandomForest, SVM e RNA para predição destes dados.  
4.	Escolha o melhor modelo com base em suas matrizes de confusão.  
5.	Indique qual modelo dá o melhor o resultado e a métrica u2lizada 
 
 
 
## 2	Estimativa de Volumes de Árvores 
 
Modelos de aprendizado de máquina são bastante usados na área da engenharia florestal (mensuração florestal) para, por exemplo, estimar o volume de madeira de árvores sem ser necessário abatê-las. 
 
O processo é feito pela coleta de dados (dados observados) através do abate de algumas árvores, onde sua altura, diâmetro na altura do peito (dap), etc, são medidos de forma exata. Com estes dados, treinase um modelo de AM que pode estimar o volume de outras árvores da população. 
 
Os modelos, chamados alométricos, são usados na área há muitos anos e são baseados em regressão (linear ou não) para encontrar uma equação que descreve os dados. Por exemplo, o modelo de Spurr é dado por: 
 
Volume = b0 + b1 * dap2 * Ht 
 
Onde dap é o diâmetro na altura do peito (1,3metros), Ht é a altura total. Tem-se vários modelos alométricos, cada um com uma determinada característica, parâmetros, etc. Um modelo de regressão envolve aplicar os dados observados e encontrar b0 e b1 no modelo apresentado, gerando assim uma equação que pode ser usada para prever o volume de outras árvores. 
 
Dado o arquivo Volumes.csv, que contém os dados de observação, escolha um modelo de aprendizado de máquina com a melhor estimativa, a partir da estatística de correlação. 
 
Tarefas 
1.	Carregar o arquivo Volumes.csv (http://www.razer.net.br/datasets/Volumes.csv) 
2.	Eliminar a coluna NR, que só apresenta um número sequencial 
3.	Criar partição de dados: treinamento 80%, teste 20% 
4.	Usando o pacote "caret", treinar os modelos: Random Forest (rf), SVM (svmRadial), Redes 
Neurais (neuralnet) e o modelo alométrico de SPURR 
 
§	O modelo alométrico é dado por: Volume = b0 + b1 * dap2 * Ht 
 
alom <- nls(VOL ~ b0 + b1*DAP*DAP*HT, dados, 
start=list(b0=0.5, b1=0.5)) 
 
5.	Efetue as predições nos dados de teste 
6.	Crie suas próprias funções (UDF) e calcule as seguintes métricas entre a predição e os dados observados 
 
§	Coeficiente de determinação: R2 
 
  
 
  onde 𝑦! é o valor observado, 𝑦"" é o valor predito e 𝑦# é a média dos valores 𝑦! observados. Quanto mais perto de 1 melhor é o modelo; 
 	 
 
§	Erro padrão da estimativa: Syx 
 
  
 	esta métrica indica erro, portanto quanto mais perto de 0 melhor é o modelo; 
 
§	Syx% 
 
  
 
 	esta métrica indica porcentagem de erro, portanto quanto mais perto de 0 melhor é o modelo; 
 
 
7.	Escolha o melhor modelo. 
