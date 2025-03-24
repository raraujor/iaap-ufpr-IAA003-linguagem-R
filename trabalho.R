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
if (!require("mlbench")) {
  install.packages("mlbench")
}
library("caret")
library("mlbench")

#1 Pesquisa com Dados de Satélite (Satellite)

#1. Carregue a base de dados Satellite
data(Satellite)
print(summary(Satellite))

set.seed(7)

satellite_mini <- Satellite[c('x.17', 'x.18', 'x.19', 'x.20', 'classes')]
print(head(satellite_mini))

#2. Crie par2ções contendo 80% para treino e 20% para teste
indices <- createDataPartition(satellite_mini$classes, p=0.8, list = FALSE)
treino <- satellite_mini[indices, ]
teste <- satellite_mini[-indices, ]

#3. Treine modelos RandomForest, SVM e RNA para predição destes dados.
print('Treinando rf...')
rf <- caret::train(classes~., data=treino, method='rf')
print('Treinando svm...')
svm <- caret::train(classes~., data=treino, method='svmRadial')
print('Treinando rna...')
rna <- caret::train(classes~., data=treino, method='nnet')
print('Treinamento completo!')

#4. Escolha o melhor modelo com base em suas matrizes de confusão.
predict.rf <- predict(rf, teste)
predict.svm <- predict(svm, teste)
predict.rna <- predict(rna, teste)

print(confusionMatrix(predict.rf, teste$classes))
print(confusionMatrix(predict.svm, teste$classes))
print(confusionMatrix(predict.rna, teste$classes))

# 5. Indique qual modelo dá o melhor o resultado e a métrica utilizada
" 
  Três modelos foram treinados na base Satellite:
    RandomForest
      Acurácia: 84,19%
    SVM
      Acurácia: 87,07%
    RNA
      Acurácia: 80,84%
  Analisando as métricas acurácia dos modelos, o melhor resultado é o SVM com uma acurácia de 87,07%
"


