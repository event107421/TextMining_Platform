dcard_crawl <- function(query, record){
  # query <- "house"
  # record <- 300
  crawl_times <- ceiling(record/30)
  # popular=false 為搜尋最新文章、popular=false為搜尋熱門文章
  # dcard爬蟲一開始先爬前30篇，接下來找到前30篇的最後一篇id後，加上before參數，找這個id前的30篇，以此類推
  url <- paste0("https://www.dcard.tw/_api/forums/", query,"/posts?popular=false")
  page.info <- fromJSON(url)
  page.info$url <- paste0("https://www.dcard.tw/f/", query, "/p/", page.info$id, "-",
                     sapply(page.info$title, URLencode, USE.NAMES = FALSE))
  page.info %<>% select(id, title, url, excerpt, createdAt, updatedAt, commentCount, likeCount,
                   topics, gender, school, department, media)
  last_id <- page.info[nrow(page.info), "id"]
  for (i in 1:(crawl_times-1)) {
    url_before <- paste0("https://www.dcard.tw/_api/forums/", query, "/posts?popular=false&before=", last_id)
    page_before <- fromJSON(url_before)
    page_before$url <- paste0("https://www.dcard.tw/f/", query, "/p/", page_before$id, "-",
                       sapply(page_before$title, URLencode, USE.NAMES = FALSE))
    page_before %<>% select(id, title, url, excerpt, createdAt, updatedAt, commentCount, likeCount,
                     topics, gender, school, department, media)
    last_id <- page_before[nrow(page_before), "id"]
    page.info <- rbind(page.info, page_before)
    i <- i+1
  }
  return(page.info)
}