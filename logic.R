# Gene Expression Analysis App
# logic.r
#
# Nick Burns
# Sept, 2016

library(shiny)
library(DESeq2)
library(RColorBrewer)
library(data.table)

extract_expression <- function (file_name) {
    expr_data <- fread(file_name)
    
    # filter out genes with low expression
    expr_data <- filter_and_normalise(expr_data)
    
    return (expr_data)
}

filter_and_normalise <- function (x, eps = 10) {
    tmp <- x[, -c("Gene"), with = FALSE]
    idx <- which(rowSums(tmp) > eps)
    
    tmp <- tmp[idx, lapply(.SD, log_cpm)]
    tmp[, Gene := x[idx, Gene]]
    
    return (tmp)
}

log_cpm <- function (x) {
    log2(0.5 + x / sum(x) * 1000000)
}

by_gene <- function (x, eps = 3) {
    gene_names <- x[, Gene]
    tmp <- t(as.matrix(x[, -c("Gene"), with = FALSE]))
    
    high_var_genes <- which(apply(tmp, 2, sd) > log2(eps))
    tmp <- tmp[, high_var_genes]
    colnames(tmp) <- gene_names[high_var_genes]
    
    return (t(tmp))
}
display_heatmap <- function (x, colours = NULL) {

    heatmap(x, col = colours)
    
}

get_clusters <- function (x, n_clusters = 4) {
    
    gene_names <- rownames(x)

    tree <- hclust(dist(x))
    clusters <- cutree(tree, n_clusters)
    
    cluster_data <- data.table(x)
    cluster_data[, Gene := gene_names]
    cluster_data[, ClusterID := clusters]
    
    return(cluster_data[order(ClusterID)])
    
}