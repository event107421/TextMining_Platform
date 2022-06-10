library(tmcn)
library(xml2)
library(dplyr)
mobile01_post_crawl <- function(name, pages_s, pages_e){
  # name <- "638"
  # pages_s <- "1"
  # pages_e <- "2"
  result.urls <-  paste0('https://www.mobile01.com/topiclist.php?f=', name)
  html.page <- read_html(url(result.urls))
  end_page <- xml_find_all(html.page, "//*[@id='section']/div[1]/div[2]/a[6]") %>% xml_text() %>% as.numeric()
  
  page.info <- data.frame()
  for (p in pages_s:pages_e){
    result.urls <- paste0(result.urls, '&p=', p)
    html.page <- read_html(url(result.urls))
    title <- xml_find_all(html.page, "//*[@id='maincontent']/div[6]/table/tbody/tr/td[1]") %>% xml_text() %>% toTrad()
    reply_amount <- xml_find_all(html.page, "//*[@id='maincontent']/div[6]/table/tbody/tr/td[2]") %>% xml_text() %>% gsub(",", "", .) %>% as.numeric()
    content_url <- xml_find_all(html.page, "//*[@id='maincontent']/div[6]/table/tbody/tr/td[1]/span/a") %>% xml_attr("href") %>% paste0("https://www.mobile01.com/", .)
    
    content <- data.frame()
    comment <- data.frame()
    for (i in 1:length(url)) {
      html.page <- read_html(url(content_url[i]))
      page_content <- xml_find_all(html.page, "//*[@id='forum-content-main']/article[1]/div/div[2]") %>% xml_text() %>% toTrad() %>% gsub("[\n ]", "", .) %>% data.frame(page_content = .)
      content <- rbind(content, page_content)
      # mobile01爬評論時因為PO文算在第一篇所以到時候要記得把第一篇刪除
      # page_comment <- xml_find_all(html.page, "//*[@id='forum-content-main']/article/div/div[2]") %>% xml_text() %>% toTrad() %>% gsub("[\n ]", "", .) %>% data.frame(page_content = .)
    }
    info <- data.frame(title, reply_amount, content_url, content)
    page.info <- rbind(page.info, info)
  }
  return(page.info)
}

