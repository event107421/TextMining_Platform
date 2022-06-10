cna_crawl <- function(query, page_s, page_e){
  #query <- "%E6%96%B0%E5%8D%97%E5%90%91"
  #p <- 1
  query <- iconv(query, from='UTF-8', to='UTF-8')
  q <- URLencode(query)
  page.info <- data.frame()
  for (p in page_s:page_e){
    result.urls = paste0('http://www.cna.com.tw/search/hysearchws.aspx?q=', q, '&p=', p)
    
    html.page = read_html(url(result.urls))
    
    xpath_url = "//*[@class='search_result_list']/ul/li/a"
    target_url = xml_find_all(html.page, xpath_url)
    download.url = unlist(xml_attr(target_url, "href"))
    download.url = paste0("http://www.cna.com.tw", download.url)
    
    xpath_title = "//*[@class='list_info']/h2"
    target_title = xml_find_all(html.page, xpath_title)
    title = xml_text(target_title)
    title <- gsub("\n",replacement="",title)
    title <- gsub("\t",replacement="",title)
    content <- data.frame()
    for (j in 1:length(download.url)){
      content.page <- read_html(download.url[j])
      xpath_content <- "//*[@class='article_box']/section/p"
      content_target <- xml_find_all(content.page, xpath_content)
      content_start <- xml_text(content_target)
      content_fin <- ""
      for (k in 1:length(content_start)){
        content_fin <-paste0(content_fin, content_start[k])
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
