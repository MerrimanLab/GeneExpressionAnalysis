# Gene Expression Analysis App
# server.r
#
# Nick Burns
# Sept, 2016

library(shiny)
library(DESeq2)
library(RColorBrewer)
library(data.table)
source("logic.R")

# max import dataset = 300 MB
options(shiny.maxRequestSize = 300 * 1024^2)

shinyServer(function (input, output) {
    
    expr_data <- NULL
    data_by_gene <- NULL
    cluster_data <- NULL
    
    observeEvent(input$expr_data_file, {
        
        expr_data <<- extract_expression(input$expr_data_file$datapath)
        
        output$ui_table_data <- renderUI({
            dataTableOutput("expr_data_table")
        })
        output$expr_data_table <- renderDataTable(expr_data,
                                                  options = list(pageLength = 10))
        output$ui_info <- renderUI({
            tags$div(
                p("Expression data successfully read in.", class = "standardtext"),
                p("Genes with low expression (sum across all samples < 10) filtered out.", class = "standardtext"),
                p("Successfully log2-cpm normalised.", class = 'standardtext')
            )
        })
    
    })
    
    observeEvent(input$btn_heatmap, {
        
        hmcol = colorRampPalette(brewer.pal(9, "GnBu"))(16)
        data_by_gene <<- by_gene(expr_data, eps = input$sld_eps)

        output$ui_display <- renderUI({
            plotOutput("plt_heatmap")
        })
        output$plt_heatmap <- renderPlot({
            validate(need(expr_data, "no expression data loaded..."))
            display_heatmap(data_by_gene, colours = rev(hmcol))
        })
        output$expr_data_table <- renderDataTable({
            genes <- rownames(data_by_gene)
            tmp <- data.table(data_by_gene)
            tmp[, Gene := genes]
            
            tmp
        })
    })
    
    observeEvent(input$btn_cluster, {
        
        clusters <- get_clusters(data_by_gene, n_clusters = input$txt_clusters)
        cluster_data <<- data.table(clusters)

        output$expr_data_table <- renderDataTable(
            cluster_data,
            options = list(pageLength = 10)
        )
    })
    
    output$btn_download <- downloadHandler(
        filename = function () {
            paste("Data-", Sys.Date(), ".csv", sep = "")
        },
        content = function(con) {
            write.csv(cluster_data, con)
        }
    )
    
})