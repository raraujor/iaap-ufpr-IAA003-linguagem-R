if (!require("e1071")) {
  install.packages("e1071")
}
if (!require("randomForest")) {
  install.packages("randomForest")
}
if (!require("kernlab")) {
  install.packages("kernlab")
}
if (!require("caret")) {
  install.packages("caret")
}
if (!require("neuralnet")) {
  install.packages("neuralnet")
}
library("caret")
library("neuralnet")

# 2 Estimativa de Volumes de Árvores
## 1. Carregar o arquivo Volumes.csv (http://www.razer.net.br/datasets/Volumes.csv)
volumes_df <- read.csv2('http://www.razer.net.br/datasets/Volumes.csv')

## 2. Eliminar a coluna NR, que só apresenta um número sequencial
volumes_df$NR <- NULL

## 3. Criar partição de dados: treinamento 80%, teste 20%
indices <- createDataPartition(volumes_df$VOL, p = 0.8, list = FALSE)
treino <- volumes_df[indices, ]
teste <- volumes_df[-indices, ]

## 4. Usando o pacote "caret", treinar os modelos: Random Forest (rf), SVM (svmRadial), Redes Neurais (neuralnet) e o modelo alométrico de SPURR
print('Treinando modelo RF')

rf <- caret::train(VOL~., data=treino, method="rf")

print('Treinando modelo SVM')
svm <- caret::train(VOL~., data=treino, method="svmRadial")

print('Treinando modelo Redes Neurais')
rna <- caret::train(VOL~., data=treino, method="neuralnet")

print('Treinando modelo alométrico')
alom <- nls(VOL ~ b0 + b1*DAP*DAP*HT, volumes_df, start=list(b0=0.5, b1=0.5))

## 5. Efetue as predições nos dados de teste
predict.rf <- predict(rf, teste)
predict.svm <- predict(svm, teste)
predict.rna <- predict(rna, teste)
predict.alom <- predict(alom, teste)

## 6. Crie suas próprias funções (UDF) e calcule as seguintes métricas entre a predição e os dados observados

r_quadrado <- function(y, y_hat) {
  "
    Quanto mais perto de 1 melhor é o modelo;
  "
  y_media = mean(y)
  return (1 - (sum((y - y_hat) ^ 2) / sum((y - y_media) ^ 2)))
}

erro_padrao_estimativa <- function(y, y_hat) {
  "
    Esta métrica indica erro, portanto quanto mais perto de 0 melhor é o modelo
  "
  n <- length(y)
  return (sqrt( sum((y - y_hat) ^ 2) / (n - 2)))
}

erro_padrao_porc <- function(y, y_hat) {
  "
    esta métrica indica porcentagem de erro, portanto quanto mais perto de 0 melhor é o modelo
  "
  s_yx = erro_padrao_estimativa(y, y_hat)
  y_media = mean(y)
  return ((s_yx / y_media) * 100)
}

## 7. Escolha o melhor modelo.
r_quadrado.rf <- r_quadrado(teste$VOL, predict.rf)
erro_padrao.rf <- erro_padrao_estimativa(teste$VOL, predict.rf)
erro_padrao_porc.rf <- erro_padrao_porc(teste$VOL, predict.rf)
cat("=================Randon Forest(rf)===================")
print(paste("Coeficiente de determinação: R2", r_quadrado.rf))
print(paste("Erro padrão da estimativa: Syx", erro_padrao.rf))
print(paste("Erro padrão da estimativa: Syx%", erro_padrao_porc.rf))
cat("=====================================================")

r_quadrado.svm <- r_quadrado(teste$VOL, predict.svm)
erro_padrao.svm <- erro_padrao_estimativa(teste$VOL, predict.svm)
erro_padrao_porc.svm <- erro_padrao_porc(teste$VOL, predict.svm)
cat("=================SVM (svmRadial)====================")
print(paste("Coeficiente de determinação: R2", r_quadrado.svm))
print(paste("Erro padrão da estimativa: Syx", erro_padrao.svm))
print(paste("Erro padrão da estimativa: Syx%", erro_padrao_porc.svm))
cat("====================================================")

r_quadrado.rna <- r_quadrado(teste$VOL, predict.rna)
erro_padrao.rna <- erro_padrao_estimativa(teste$VOL, predict.rna)
erro_padrao_porc.rna <- erro_padrao_porc(teste$VOL, predict.rna)
cat("=================Redes Neurais(neuralnet)===========")
print(paste("Coeficiente de determinação: R2", r_quadrado.rna))
print(paste("Erro padrão da estimativa: Syx", erro_padrao.rna))
print(paste("Erro padrão da estimativa: Syx%", erro_padrao_porc.rna))
cat("===================================================")

r_quadrado.alom <- r_quadrado(teste$VOL, predict.alom)
erro_padrao.alom <- erro_padrao_estimativa(teste$VOL, predict.alom)
erro_padrao_porc.alom <- erro_padrao_porc(teste$VOL, predict.alom)
cat("=================Modelo alométrico===================")
print(paste("Coeficiente de determinação: R2", r_quadrado.alom))
print(paste("Erro padrão da estimativa: Syx", erro_padrao.alom))
print(paste("Erro padrão da estimativa: Syx%", erro_padrao_porc.alom))
cat("=================================================")

"
  Conclusão: 
    Baseado nas métricas acima, o melhor modelo é o SVM (svmRadial) que obteve um R2 de 0.87 e Syx de 0.15 e Syx de 11%
"
