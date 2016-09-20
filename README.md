# GeneExpressionAnalysis
Shiny app for basic exploration of gene expression datasets  

## Input data  

You can supply your own RNAseq (or microarray) gene expression data as a comma separated file. The data should be raw read counts (i.e. not normalised counts), with the following format:  

| Sample 1 | Sample 2 | Sample 3 | ... | Gene |  
| -------- | -------- | -------- | --- | ---- |  
| 500 | 12 | 65 | ... | gene name 1 |  
| 2 | 0 | 18 | ... | gene name 2 |  
| ... | ... | ... | ... | ... |  

i.e. rows = genes, columns = samples. The column headers can be anything sensible, except for the Gene column which should be called ```Gene```.  The order of the columns does not matter (e.g. you could have the Gene column at the start), but the heatmap will display the samples in the same order as they are in the file. So if you have time-series data it would be sensible to put the columns in time-order :)  

There is an example dataset included in this repo. See GeneExpressionAnalysis/data  


## Wishlist  

  - Change the threshold widget label from "log fold change" to "variablility' or something similar.  
  - include some validation on the number of genes clustered. Limit this to < 5000 genes.  
