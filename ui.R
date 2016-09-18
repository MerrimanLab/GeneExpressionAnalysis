# Gene Expression Analysis App
# ui.r
#
# Nick Burns
# Sept, 2016

library(shiny)
library(DESeq2)
library(RColorBrewer)
library(data.table)

shinyUI(fluidPage(
    
    theme = "interface_styles.css",
    headerPanel(""),
    sidebarPanel(
        h2("Gene Expression Clustering"),
        br(),
        hr(),
        br(),
        
        fileInput("expr_data_file", p("Gene expression data file: ", class = "boldtext")),
        hr(),
        
        uiOutput("ui_info"),
        br(),
        hr(),
        
        p("Clustering options", class = "boldtext"),
        br(),
        p("Adjust the slider below to filter out genes.", class = "standardtext"),
        sliderInput("sld_eps", p("Fold change threshold:", class = "standardtext"),
                    min = 1, max = 10, step = 0.5, value = 4),
        br(),
        actionButton("btn_heatmap", "Display heatmap", class = "button"),
        br(),
        br(),
        
        p("Input the number of clusters that you would like:", class = 'standardtext'),
        textInput("txt_clusters", ""),
        br(),
        actionButton("btn_cluster", "Generate clusters", class = "button"),
        br(),
        br(),
        hr(),
        
        downloadButton("downloadData", "Save cluster data"),
        br(),
        br()
        
    ),
    mainPanel(
        uiOutput("ui_display"),
        br(),
        uiOutput("ui_table_data")
    )
))