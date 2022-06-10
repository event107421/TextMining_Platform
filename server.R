server <- function(input, output) {
  ptt <- eventReactive(input$update_ptt,{
    data_ptt <- ptt_post_crawl(input$ptt_name, input$ptt_number_s, input$ptt_number_e)
    ptt_data_web <- data_ptt[[1]]
    ptt_data_web$URL <- paste0('<a href="',ptt_data_web$URL,'">', ptt_data_web$URL,'</a>')
    ptt_data_web <- datatable(ptt_data_web, escape = FALSE)
    ptt <- list(data_ptt, ptt_data_web)
    return(ptt)
  })
  
  output$output_ptt<-renderDataTable({
    if (is.null(ptt())) {
      return(NULL)
    }
    data_ptt <- ptt()[[2]]
  })
  
  observeEvent(input$download_ptt,{
    path <- input$seat_ptt
    setwd(path)
    ptt_post <- ptt()[[1]][[1]]
    ptt_comment <- ptt()[[1]][[2]]
    if (input$radio_ptt == "1"){
      for(i in 1:nrow(ptt_post)){
        write.table(ptt_post$content[i], paste0(gsub("[[:punct:]]", "", ptt_post$title[i]), ".txt"), row.names=FALSE, col.names=FALSE, fileEncoding = "UTF-8")
        single_comment <- ptt_comment[ptt_comment$title == ptt_post$title[i],] %>% .[, -1]
        write.csv(single_comment, paste0("(評論)", gsub("[[:punct:]]", "", ptt_post$title[i]), ".csv"), row.names=FALSE)
      }
    }
    else{
      write.csv(ptt_post, "PTT_POST.csv", row.names = FALSE)
      write.csv(ptt_comment, "PTT_Comment.csv", row.names = FALSE) 
    }
  })
  
  news <- eventReactive(input$update_news,{
    news_select <- as.numeric(input$news_select)
    data_news <- switch(news_select,
                        ettoday_crawl(input$news_keyword, input$news_page_s, input$news_page_e),
                        cna_crawl(input$news_keyword, input$news_page_s, input$news_page_e),
                        ltn_crawl(input$news_keyword, input$news_page_s, input$news_page_e),
                        setn_crawl(input$news_keyword, input$news_page_s, input$news_page_e),
                        udn_crawl(input$news_keyword, input$news_page_s, input$news_page_e))
    news_data_web <- data_news
    news_data_web$URL <- paste0('<a href="',news_data_web$URL,'">', news_data_web$URL,'</a>')
    news_data_web <- datatable(news_data_web, escape = FALSE)
    news <- list(data_news, news_data_web)
    return(news)
  })
  
  output$output_news <- renderDataTable({
    if (is.null(news())) {
      return(NULL)
    }
    data_news <- news()[[2]]
  })
  
  observeEvent(input$download_news,{
    path <- input$seat_news
    setwd(path)
    news_post <- news()[[1]]
    news_select <- as.numeric(input$news_select)
    news_webname <- c("ettoday", "CNA", "LTN", "SETN", "UDN")
    write.csv(news_post, paste0(news_webname[news_select], "_POST.csv"), row.names = FALSE)
  })
  
  text <-  reactive({
    inFile <- input$files
    if (is.null(inFile)) {
      return(NULL)
    }
    #setwd("H:\\展示的平台\\文字探勘")
    wk <- worker(dict="jieba.dict.utf8",hmm="hmm_model.utf8",user="user.dict.utf8")
    if (input$radio_text == "1"){
      #setwd("H:\\輿情相關\\autoplatform\\platform")
      #datapath <- DirSource("test2")$file
      text_data <- do.call(rbind,  lapply(inFile$datapath,  function(M){
        text_data <-scan(M,  what="character",  sep=NULL,  fileEncoding="UTF-8")
        text_data <- paste(text_data,  collapse = "")
      }))
      text_data <- gsub("[A-Za-z0-9 -_　【】]", "",text_data)
      words <- list()
      for (i in 1:length(text_data)){
        words_data <- wk[text_data[i]]
        words[[i]] <- iconv(words_data[nchar(words_data) > 1], "UTF-8", "BIG5")
      }
    }
    else if (input$radio_text == "2"){
      #setwd("C:\\Users\\hzsh\\Desktop\\新增資料夾")
      #text_data <- read.csv("ettoday_POST.csv", header = TRUE)
      text_data <- read.csv(inFile$datapath, header = input$header, stringsAsFactors = FALSE, encoding = "big5")
      text_data <- text_data[!is.na(text_data[,1]), ]
      text_data <- gsub("[A-Za-z0-9 -_　【】]", "",text_data)
      words <- list()
      for (i in 1:nrow(text_data)){
        words_data <- wk[text_data[i,1]]
        words[[i]] <- iconv(words_data[nchar(words_data) > 1], "UTF-8", "BIG5")
      }
    }
    else if (input$radio_text == "3"){
      text_data <- news()[[1]]
      text_data <- text_data[!is.na(text_data[,1]), ]
      text_data <- gsub("[A-Za-z0-9 -_　【】]", "",text_data)
      words <- list()
      for (i in 1:nrow(text_data)){
        words_data <- wk[text_data[i,1]]
        words[[i]] <- iconv(words_data[nchar(words_data) > 1], "UTF-8", "BIG5")
      }
    }
    
    corp <- Corpus(VectorSource(words))
    .strsplit_space_tokenizer <- function(x) {
      unlist(strsplit(as.character(x), "[[:space:]]+"))
    }
    
    dtm <- DocumentTermMatrix(corp, control = list(wordLengths=c(2,Inf),removeNumbers = TRUE,
                                                   removePunctuation  = list(preserve_intra_word_dashes = FALSE),
                                                   weighting = weightTf,encoding = "UTF-8",tokenize = .strsplit_space_tokenizer))
    tdm <- TermDocumentMatrix(corp, control = list(wordLengths=c(2, 4),removeNumbers = TRUE,
                                                   removePunctuation = list(preserve_intra_word_dashes = FALSE),
                                                   weighting = weightTf,encoding = "UTF-8",tokenize = .strsplit_space_tokenizer))
    text_out <- list(words = words, docs = corp, dtm = dtm, tdm = tdm)
  })
  
  analysis_wordcloud <- eventReactive(input$wordcloud,{
    wordcloud_text <- unlist(text()[[1]])
    table1 <- table(wordcloud_text)
    wordsDf <- data.frame(WORD = names(table1), FREQ = as.vector(table1), stringsAsFactors = FALSE)
    wordsDf <- wordsDf[order(wordsDf$FREQ),]
    wordsDf_200 <- wordsDf[(nrow(wordsDf)-200):nrow(wordsDf),]
    wordsDf_filiter <- subset(wordsDf_200[1:(input$word_number),], FREQ >= input$freq[1] & FREQ <= input$freq[2])
    wordcloud_out <- list(wordsDf, wordsDf_filiter)
  })
  
  output$wordfreq_data <- renderDataTable({#跟詞雲圖衝到
    if (is.null(analysis_wordcloud()[[1]])) {
      return(NULL)
    }
    analysis_wordcloud()[[1]]
  })
  
  output$wordcloud_plot <- renderWordcloud2({
    wordsDf_filiter <- analysis_wordcloud()[[2]]
    p <- wordcloud2(wordsDf_filiter, color = "random-light", backgroundColor = "grey", size = 0.5)
    p
  })
  
  output$download_wordfreq <- downloadHandler(
    filename = function() {paste("wordfreq", ".csv", sep='') },
    content = function(file) {write.csv(analysis_wordcloud()[[1]], file, row.names = FALSE)})
  #################################Association######################
  asso <- eventReactive(input$text_ass,{
    moss <- data.frame(findAssocs(text()[[3]], input$keyword, input$corr))#搜尋跟八卦有關，且關聯性大於0.5
    moa <- moss[,1] %>% cbind(rownames(moss),.)
    colnames(moa) <- c("word", "cor")
    corrdata <- as.data.frame(moa)
  })
  
  output$ass_data <- renderDataTable({
    if (is.null(asso())) {
      return(NULL)
    }
    t <- asso()
  })
  
  output$download_wordfreq <- downloadHandler(
    filename = function() {paste("wordfreq", ".csv", sep='') },
    content = function(file) {write.csv(asso(), file, row.names = FALSE)})
}

shinyApp(ui, server)