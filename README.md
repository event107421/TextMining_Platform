<<<<<<< HEAD
# 文字探勘平台
`此文字探勘平台分為三個部分，第一個部分是平台介紹，第二個部分是文章及新聞資料的爬取，可供使用者下載並整合網路上文章及新聞，目前可下載資料的網站為批踢踢實業坊(PTT)、東森新聞網 (Ettoday)、中央通訊社(CNA)、 自由時報(LTN)、三立新聞網 (SETN)、聯合新聞網(UDN)，第三個部分為文字探勘分析，提供較初步的分析方法，分別是詞雲圖、字詞間的關聯分析，可供使用者參考。`

## (一) 平台介紹：
`此分頁向使用者解說每個頁面所提供之功能`
![圖 1-1 平台介紹](./Description_Image/1.png)

## (二) 網站文章及新聞網站資料下載：
`此分頁分為兩個部分，第一個部分為批踢踢實業坊(PTT)文章資料下 載，第二個部分是可供使用者選擇不同的新聞網站進行資料下載。`
### 1. 第一個部分：
批踢踢實業坊(PTT)文章資料下載，可以讓使用者輸入不同的看板名稱，輸入起始頁數及最後頁數，可以選擇下載檔案類型，有 txt 檔及 csv 檔供使用者選擇，也可以輸入想要儲存檔案的路徑。
下載檔案時，提醒:
選擇 txt 檔時，每篇 PO 文為單獨 txt 檔，評論則為單獨 csv 檔
選擇 csv 檔時，PO 文會被合併為一個 csv 檔，評論也會被合併為 csv 檔
![圖 2-1 PTT文章下載界面](/home/aaon/文件/assets/1543803099995.png)
### 2. 第二個部分：
新聞網站資料下載，有東森新聞網(Ettoday)、中央通訊社(CNA)、自由時報(LTN)、三立新聞網(SETN)、聯合新聞網(UDN)，五個新聞網站供使用者進行選擇，輸入想查詢新聞的關鍵字後，在輸入起始頁碼與最後頁碼即可進行搜尋，此部分一樣可以選擇下載的檔案類型以及儲存檔案的路徑。
![圖 2-2 新聞下載界面](/home/aaon/文件/assets/1543803099995.png)

## (三) 基本文字探勘分析：
`此分頁分為兩個部份，第一個部份是詞雲圖，可以選擇輸入檔案的類型，分別是 txt 檔、csv 檔或是可以直接選擇本平台爬蟲資料，第二個部份是字詞間的關聯分析，可以輸入想搜尋的關鍵字詞，顯示其他字詞與關鍵字詞間的相關性。`
### 1. 第一個部分：
詞雲圖是先利用 jieba 分詞系統，將各篇文章進行斷詞斷句，再將字詞進行出現頻率的計算，也就得到每個字詞的詞頻，再以圖示的方式呈現，當字詞越大代表其出先的頻率越高，也就代表其熱門程度較高
![圖 3-1 詞雲圖](/home/aaon/文件/assets/1543803099995.png)
### 2. 第二個部分：
關聯分析，也就是讓使用者輸入有關這些主題的關 鍵字詞後，顯示其他字詞與使用者想知道的字詞間的關連性為 何。
![圖 3-2 關聯分析](/home/aaon/文件/assets/1543803099995.png)
=======
# TextMining_Platform
>>>>>>> 7a97d7454e249312a0377f3ae6d8c47cfb95ad0d
