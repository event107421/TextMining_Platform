ui <- dashboardPage(
  dashboardHeader(title = "Text Mining"),
  dashboardSidebar(
    sidebarMenu(
      # menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      h3("Home",style = "color:White;font-family: '微軟正黑體'"),
      menuItem("介紹", tabName = "Home", icon = icon("home")),
      h3("Crawl Web",style = "color:White;font-family: '微軟正黑體'"),
      # menuItem("Crawl FB", tabName = "crawlfb", icon = icon("th")),
      menuItem("Crawl PTT", tabName = "crawlppt", icon = icon("th")),
      menuItem("Crawl News Website", tabName = "crawlnews", icon = icon("th")),
      h3("Text Mining",style = "color:White;font-family: '微軟正黑體'"),
      menuItem("文字雲", tabName = "wordcloud", icon = icon("dashboard")),
      # menuItem("群集分析", tabName = "cluster", icon = icon("dashboard")),
      # menuItem("脈絡分析", tabName = "lda", icon = icon("dashboard")),
      menuItem("關聯分析", tabName = "association", icon = icon("dashboard")
      )
    )
  ),
  
  ## Body content
  dashboardBody(
    tabItems(
      tabItem(tabName = "Home",
              fluidRow(box(
                width =12,
                title = "平台設立與功能簡介",status = "primary",solidHeader = TRUE,
                h3('本平台的設立是由謝邦昌教授所帶領的研究團隊並在李艦老師的幫忙下逐漸成形。',br(),
                   '不同於以往的數值資料分析，潛藏在文字之間的資料量越來越龐大，而其中透露出來的趨勢以及信息',
                   '亦讓人無法忽略。因此我們利用',
                   span('文字探勘技術',style = "color:green;font-family: '微軟正黑體'"),
                   '結合',
                   span('爬蟲技術',style = "color:green;font-family: '微軟正黑體'"),
                   '，去建立一個',
                   span('輿情語意分析平台',style = "color:green;font-family: '微軟正黑體'"),
                   '讓使用者能夠利用平台，獲取所需的資訊。',style = "font-family: '微軟正黑體'"),
                br(),
                h4("本平台有二個主要功能，功能如下:",br(),br(),
                   span("Crawl Web",style = "font-weight:bold;color:red;font-family: '微軟正黑體'"),br(),br(),
                   "可以供使用者輸入關鍵字詞，並且利用本平台將相關文章及新聞自動爬取下來，以利於接下來的文字探勘分析。",br(),br(),
                   span("Text mining",style = "font-weight:bold;color:red;font-family: '微軟正黑體'"),br(),br(),
                   "可以供使用者自行輸入txt檔文本，或是直接用本平台所爬取的資料，進行文字探勘分析：詞雲圖及關聯分析。",br(),br()
                   # span("Facebook",style = "font-weight:bold;color:red;font-family: '微軟正黑體'"),br(),br(),
                   # "對臉書粉絲團進行爬文，並可分別對管理員貼文及粉絲留言進行分析", style = "font-family: '微軟正黑體'"
                ),
                br()
              )
              )
      ),
      # tabItem(tabName = "crawlfb",
      #         fluidRow(
      #           box(
      #             width = 3,
      #             title = "Crawl Post Data",
      #             solidHeader = TRUE,
      #             status = "primary",
      #             textInput("id", h3("Fans id:"),"tpedot"),
      #             textInput('st', h3("Input the begining time(2016/01/01):"),'2016/01/01'),
      #             textInput('ut', h3("Input the ending time(2016/03/01):"),'2016/03/01'),
      #             numericInput("obs", h3("The numbers of posts:"), 100),
      #             textInput("seat_fb",  h3("儲存路徑:"),"C:\\"),
      #             actionButton("update_fb", "搜尋"),
      #             hr(),
      #             downloadButton('download_fb', 'Download post')
      #           ),
      #           box(
      #             width = 9,
      #             title = "Facebook fans Post",
      #             solidHeader = TRUE,
      #             status = "primary",
      #             wellPanel(
      #               dataTableOutput(outputId="table1")
      #             )
      #           )
      #         )
      # ),
      
      tabItem(tabName = "crawlppt",
              fluidRow(
                box(
                  width = 3,
                  title = "Crawl PTT Post",
                  solidHeader = TRUE, 
                  status = "primary",
                  textInput("single_page", h3("URL:"),"https://www.ptt.cc/bbs/MRT/M.1488988891.A.398.html"),
                  textInput("ptt_name", h3("看板名稱:"),"Gossiping"),
                  textInput("ptt_number_s", h3("start page:"),"38984"),
                  textInput("ptt_number_e", h3("end page:"),"38984"),
                  actionButton("update_ptt", "搜尋"),
                  hr(),
                  radioButtons("radio_ptt", label = h3("請選擇下載檔案類型"),
                               choices = list("txt" = 1, "csv" = 2)),
                  textInput("seat_ptt",  h3("儲存路徑:"),""),
                  actionButton("download_ptt", "Download"),
                  h5("下載檔案時，提醒："),
                  h5("選擇txt檔時，每篇PO文為單獨txt檔，評論則為單獨csv檔"),
                  h5("選擇csv檔時，PO文會被合併為一個csv檔，評論也會被合併為csv檔")
                ),
                box(
                  width = 9,
                  title = "PTT Post",                                 
                  solidHeader = TRUE, 
                  status = "primary",
                  dataTableOutput(outputId="output_ptt")
                )
              )
      ),
      
      tabItem(tabName = "crawlnews",
              fluidRow(
                box(
                  width = 3,
                  title = "Crawl News Website",
                  solidHeader = TRUE, 
                  status = "primary",
                  selectInput("news_select", h3("新聞網選擇："), 
                              choices = list("東森新聞網(Ettoday)" = 1, "中央通訊社(CNA)" = 2,
                                             "自由時報(LTN)" = 3, "三立新聞網(SETN)" = 4,
                                             "聯合新聞網(UDN)" = 5)),
                  textInput("news_keyword", h3("關鍵字搜尋:"),"新南向"),
                  textInput("news_page_s", h3("start page:"),"1"),
                  textInput("news_page_e", h3("end page:"),"1"),
                  actionButton("update_news", "搜尋"),
                  hr(),
                  radioButtons("radio_news", label = h3("請選擇下載檔案類型"),
                               choices = list("txt" = 1, "csv" = 2)),
                  textInput("seat_news",  h3("儲存路徑:"),""),
                  actionButton('download_news', 'Download')
                ),
                box(
                  width = 9,
                  title = "News",                                 
                  solidHeader = TRUE, 
                  status = "primary",
                  wellPanel(
                    dataTableOutput(outputId="output_news")
                  )
                )
              )
      ),
      
      tabItem(tabName = "wordcloud",
              fluidRow(
                box(
                  title = "Controls",status = "warning",solidHeader = TRUE,
                  radioButtons("radio_text", label = h3("請選擇檔案類型"),
                               choices = list("txt" = 1, "csv" = 2, "平台爬蟲資料" = 3)),
                  fileInput('files', '請先選擇檔案', multiple = TRUE, accept=c('text/csv', 'csv/comma-separated-values,csv/plain')),
                  checkboxInput("header", "Header", TRUE),
                  sliderInput("freq", "詞頻控制:",min=1, max=300,value = c(2, 10)),
                  sliderInput("word_number","字詞個數:",min=1, max=200,value=50),
                  # selectInput("selectt", "詞性篩選", choices = list("名詞" = "docs", "全部詞性" = "docss"),
                  #             selected = "docss"),
                  # selectInput("wordcloud_color", "詞雲圖", choices = list("彩虹" = "rainbow", "紅色" = "red","綠色" = "green","藍色" = "blue"),
                  #             selected = "rainbow"),
                  actionButton('wordcloud', '執行'),
                  downloadButton('download_wordfreq', 'Download WordFreq'),
                  width =2,
                  collapsible = TRUE
                ),
                column(width =10,
                       box(
                         title = "Word_freq", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         dataTableOutput(outputId="wordfreq_data"),
                         width =NULL
                       ),
                       box(
                         title = "wordcloud", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         wordcloud2Output("wordcloud_plot",width = "100%", height = 800),
                         width =NULL
                       )
                )
              )
      ),
      
      tabItem(tabName = "cluster",
              fluidRow(
                box(
                  title = "Controls",status = "warning", solidHeader = TRUE,
                  sliderInput("word_size", "字體大小", min = 0.5, max = 3, value = 2),
                  numericInput("cluster_number", "集群數", min=2, max=8, value=5),
                  sliderInput("P", "顯著性", min=0, max=1, value=0.8),
                  selectInput("cluster_type", "圖形篩選",
                              choices = list("扇形圖" = "fan", "樹狀圖" = "phylogram","分支圖"="cladogram","無根樹狀圖"="unrooted"),
                              selected = "扇形圖"),
                  # selectInput("selecttt", "詞性篩選",
                  #             choices = list("名詞" = "docs", "全部詞性" = "docss"),selected = "docss"),
                  actionButton("text_cluster", "執行"),
                  downloadButton('download_clu', 'Download WordCluster'),
                  width =2,
                  collapsible = TRUE
                ),
                column(width =8,
                       box(
                         title = "cluster", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         plotOutput("plot_clu",width = "100%", height = 800),
                         width =NULL),
                       box(
                         title = "Cluster", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         dataTableOutput(outputId="cluster_data"),
                         width =NULL)
                )
              )
      ),
      
      # tabItem(tabName = "lda", 
      #         fluidRow(
      #           box(
      #             title = "Controls",status = "warning",solidHeader = TRUE,
      #             h5('步驟一'), 
      #             h5('尋找最適主題數'),
      #             downloadButton('logLiktest', strong('Download logLiktest')),
      #             
      #             h5('步驟二'),
      #             
      #             numericInput("k",'更改主題數',min=5,max=20,value=10),
      #             numericInput("k1","第幾個主題",min=1,max=20,value=3),
      #             numericInput("k2","第幾個主題",min=1,max=20,value=4),
      #             numericInput("k3","第幾個主題",min=1,max=20,value=5),
      #             
      #             h5('步驟三'),
      #             selectInput("select", label = "脈絡分析演算法", 
      #                         choices = list("最大期望值演算法(VEM)" = "VEM", "吉佈斯抽樣方法(Gibbs)" = "Gibbs", "相關主題模型(CTM)" = "CTM"), 
      #                         selected = "VEM"),
      #             selectInput("selecttttt", "詞性篩選", 
      #                         choices = list("名詞" = "docs", "全部詞性" = "docss"), 
      #                         selected = "docss"),
      #             # submitButton("Change"),
      #             actionButton("in3", "執行"),
      #             br(),
      #             h5('步驟四'),
      #             h5('下載主題脈絡對應的詞彙'),
      #             downloadButton('topic', strong('Download topic')),
      #             width =2,
      #             collapsible = TRUE
      #           ),
      #           column(width =8,
      #                  box(
      #                    title = "LDA", status = "primary", solidHeader = TRUE,
      #                    collapsible = TRUE,
      #                    plotOutput("storyplot",width = "100%", height = 800),
      #                    width =NULL),
      #                  box(
      #                    title = "Topic", status = "primary", solidHeader = TRUE,
      #                    collapsible = TRUE,
      #                    dataTableOutput(outputId="ldatopic1"),
      #                    width =NULL
      #                  ))
      #         )
      # ),
      
      tabItem(tabName = "association",
              fluidRow(
                box(
                  title = "Controls",status = "warning",solidHeader = TRUE,
                  textInput("keyword", "輸入關聯字詞:",value="八卦"),
                  numericInput("corr","關聯性",min=0,max=1,value=0.5),
                  # selectInput("selectttt", "詞性篩選",
                  #             choices = list("名詞" = "docs", "全部詞性" = "docss"),
                  #             selected = "docss"),
                  actionButton("text_ass", "執行"),
                  downloadButton('download_ass', 'Download cor_Freq'),
                  width =2,
                  collapsible = TRUE
                ),
                column(width =8,
                       box(
                         title = "Association", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         showOutput("word_association", "polycharts"),width =NULL
                       ),
                       box(
                         title = "Ass_word", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         dataTableOutput(outputId="ass_data"),
                         width =NULL
                       ))
              )
      )
    )
  )
)