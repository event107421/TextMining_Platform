ptt_post_crawl <- function(name, pages_s, pages_e){
  # name <- "Gossiping"
  # pages_s = 38984
  # pages_e = 38986
  page.info <- data.frame()
  comment <- data.frame()
  for (p in pages_s:pages_e){
    result.urls <-  paste0('https://www.ptt.cc/bbs/', name, '/index', p, '.html')
    
    html <- httr::content(GET(result.urls,config = set_cookies("over18"="1")), encoding = "UTF-8")#因為httr的content與tm內的content剛好函數名稱一樣有衝突
    xpath <- "//*[@class='title']/a" 
    target <- xml_find_all(html, xpath)
    
    title <- xml_text(target)# 解密文件的「標題」
    
    download.url <- unlist(xml_attr(target, "href"))# 解密文件的「超連結」
    download.url <- paste0("https://www.ptt.cc", download.url)
    content <- data.frame()
    #爬取文章及留言
    for (i in 1:length(download.url)){
      html_content <- content(GET(download.url[i],config=set_cookies("over18"="1")), encoding="UTF-8")
      xpath_content <- "//*[@id='main-content']/text()"
      content_target <- xml_find_all(html_content, xpath_content)
      content_start <- xml_text(content_target)
      content_start <- gsub("\n",replacement="",content_start)
      content_start <- gsub(" ",replacement="",content_start)
      content_fin <- ""
      for (j in 1:length(content_start)){
        content_fin <-paste0(content_fin, content_start[j])
      }
      content_fin <- data.frame(content_fin)
      content <- rbind(content, content_fin)
      #爬留言
      push <- xml_find_all(html_content, "//*[@class='push']")
      if (length(push) == 0){
        push <-"No comment"
        push <- data.frame(push)
      }
      else{
        push <- data.frame(substr(xml_text(push), 1, 1))
      }
      
      pushid <- xml_find_all(html_content, "//*[@class='f3 hl push-userid']")
      if (length(pushid) == 0){
        pushid <-"No comment"
        pushid <- data.frame(pushid)
      }
      else{
        pushid <- data.frame(xml_text(pushid))
      }
      
      message <- xml_find_all(html_content, "//*[@class='f3 push-content']")
      if (length(message) == 0){
        message <-"No comment"
        message <- data.frame(message)
      }
      else{
        message <- data.frame(gsub(":",replacement="", xml_text(message)))
      }
      
      time <- xml_find_all(html_content, "//*[@class='push-ipdatetime']")
      if (length(time) == 0){
        time <-"No comment"
        time <- data.frame(message)
      }
      else{
        time <- data.frame(gsub(" ", "",  gsub("\n", "", xml_text(time))))
      }
      comment_fin <- cbind(title[i], push, pushid, message, time)
      names(comment_fin) <- c('title', 'push', 'pushid', 'message', 'time')
      comment <- rbind(comment, comment_fin)
    }
    first <- data.frame(title, download.url, content, stringsAsFactors = F)
    page.info <- rbind(page.info, first)
  }
  names(page.info) <- c('title', 'URL', 'content')
  # post <- page.info %>% filter()
  # re_post <- 
  ptt_crawl <- list(page.info, comment)
  return(ptt_crawl)
}
