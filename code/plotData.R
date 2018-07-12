#!/usr/bin/env Rscript
# Functions for plotting the data used in this study
# Benjamin Sanchez


## @knitr plotLM
# Linear model plotting function
LMplot <- function(x,y,scaling,pos,fixToZero) {
  if(scaling == 1) {
    pos <- 0
  }
  lmodel <- lm(y ~ x)
  if(fixToZero) {
    lmodel$coefficients <- c(log10(scaling),1)
  } else {
    lmodel$coefficients[1] <- lmodel$coefficients[1]+log10(scaling)
  }
  n       <- length(x)
  yp      <- as.numeric(t(predict(lmodel)))
  R2      <- 1 - (sum((y - yp)^2)/sum((y - mean(y))^2))
  R2adj   <- round(1-((1-R2)*(n-1)/(n-1-1)),2)
  col_opt <- ifelse(pos==0,'red',ifelse(pos == 1,'green','black'))
  abline(lmodel, col = col_opt)
  text(min(x, na.rm = TRUE),max(y, na.rm = TRUE)-pos-0.5, bquote('R'^2 ~ '=' ~ .(R2adj)), pos = 4, col = col_opt)
}

## @knitr plotES
# ES plotting function:
ESplot <- function(ESdata,scaling1,scaling2,name,fixToZero) {
  x    <- log10(ESdata[[paste0('iBAQ.L.T4h_',tolower(name))]])
  y    <- log10(ESdata$amount.pg)
  y    <- y[!is.na(x)]
  x    <- x[!is.na(x)]
  if(length(scaling1) > 1) {
    scaling1 <- mean(scaling1[grep(name,names(scaling1))])
  }
  if(length(scaling2) > 1) {
    scaling2 <- mean(scaling2[grep(name,names(scaling2))])
  }
  plot(x,y, col = 'blue', xaxt = 'n', yaxt = 'n', main = name)
  LMplot(x,y,1,0,FALSE)
  LMplot(x,y,scaling1,1,fixToZero)
  LMplot(x,y,scaling2,2,FALSE)
}
# plot all ES plots
ESplots <- function(ESdata,scaling1,scaling2,fixToZero) {
  par(mfrow = c(2,3), mar = c(0, 0, 1, 0) + 0.5, cex = 1)
  ESplot(ESdata,scaling1,scaling2,'top5_batch1',fixToZero)
  ESplot(ESdata,scaling1,scaling2,'top5_batch2',fixToZero)
  ESplot(ESdata,scaling1,scaling2,'top5_batch3',fixToZero)
  ESplot(ESdata,scaling1,scaling2,'top10_batch1',fixToZero)
  ESplot(ESdata,scaling1,scaling2,'top10_batch2',fixToZero)
  ESplot(ESdata,scaling1,scaling2,'top10_batch3',fixToZero)
}


## @knitr plotTotalProt
protPlot <- function(data,pattern) {
  abundances <- data[,grep(pattern,names(data))]
  names(abundances) <- gsub(pattern,'',names(abundances))
  totProt <- colSums(abundances, na.rm = TRUE)/1e6  #ug in sample
  par(mfcol = c(1,1), mar = c(2.5,2.5,1,1), cex = 1.5)
  barplot(totProt, names.arg = NULL, col = 1:length(names(abundances)), cex.names = 0.5)
}
