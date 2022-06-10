setn_crawl <- function(query, page_s, page_e){
  #query <- "%E6%96%B0%E5%8D%97%E5%90%91"
  #p <- 1
  query <- iconv(query, from='UTF-8', to='UTF-8')
  q <- URLencode(query)
  page.info <- data.frame()
  for (p in page_s:page_e){
    result.urls <- paste0('http://www.setn.com/search.aspx?q=', query, '&r=0&p=', p)
    
    html.page <- read_html(url(result.urls))
    
    xpath <- "//*[@id='conLt']/div/div/div/h3/a" 
    target <- xml_find_all(html.page, xpath)
    title <- xml_text(target)
    
    download.url <- unlist(xml_attr(target, "href"))
    download.url <- paste0("http://www.setn.com/", download.url)
    
    content <- data.frame()
    for (i in 1:length(download.url)){
      content.page <- read_html(download.url[i])
      xpath_content <- "//*[@id='Content1']/p"
      content_target <- xml_find_all(content.page, xpath_content)
      content_start <- xml_text(content_target)
      content_fin <- ""
      for (j in 1:length(content_start)){
        content_fin <-paste0(content_fin, content_start[j])
      }
      content_fin <- data.frame(content_fin)
      content <- rbind(content, content_fin)
    }
    first <- data.frame(title, download.url, content, stringsAsFactors = F)
    names(first) <- c('title', 'URL', 'content')
    page.info <- rbind(page.info, first)
  }
  return(page.info)
}
