yahoonews_crawl <- function(query, record){
  # query <- "大數據"
  # record <- 100
  pages <- seq(10, record, by = 10)
  query <- URLencode(iconv(query, from='UTF-8', to='UTF-8'))
  page.info <- data.frame()
  for (i in 1:length(pages)) {
    url <- paste0("https://tw.news.yahoo.com/_td-news/api/resource/NewsSearchService;loadMore=true;mrs=%7B%22size%22%3A%7B%22w%22%3A220%2C%22h%22%3A128%7D%7D;offset=", pages[i], ";query=", query,";usePrefetch=false?bkt=news-TW-zh-Hant-TW-def&device=desktop&feature=videoDocking&intl=tw&lang=zh-Hant-TW&partner=none&prid=alndmitdqcir7&region=TW&site=news&tz=Asia%2FTaipei&ver=2.0.1063&returnMeta=true")
    page_content <- fromJSON(url)$data
    names(page_content)[which(names(page_content) %in% "url")] <- "news_url"
    page_content <- page_content %>% cbind(., .$thumbnail) %>% select(title, news_url, summary, published_at, provider_name, provider_id, url, original_img)
    page_content$news_url <- paste0("https://tw.news.yahoo.com", page_content$news_url)
    page.info <- rbind(page.info, page_content)
  }
  return(page.info)
}