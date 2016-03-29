path <- "Coursera-SwiftKey/final"

loc.de_DE <- "de_DE"
loc.en_US <- "en_US"
loc.fi_FI <- "fi_FI"
loc.ru_RU <- "ru_RU"

locales <- c(de_DE = "de_DE", en_US = "en_US", fi_FI = "fi_FI", ru_RU = "ru_RU")

file.blogs <- ".blogs.txt"
file.news <- ".news.txt"
file.twitter <- ".twitter.txt"

file_Us_blogs <- paste0(loc.en_US, file.blogs)
file_Us_news <- paste0(loc.en_US, file.news)
file_Us_twitter <- paste0(loc.en_US, file.twitter)

path_Us_blogs <- paste0(path, "/", loc.en_US, "/", file_Us_blogs)
path_Us_news <- paste0(path, "/", loc.en_US, "/", file_Us_news)
path_Us_twitter <- paste0(path, "/", loc.en_US, "/", file_Us_twitter)

# Small part of data.

samle.dir <- "sample"

sample_Us_blogs <- paste0(samle.dir, "/", file_Us_blogs)
sample_Us_news <- paste0(samle.dir, "/", file_Us_news)
sample_Us_twitter <- paste0(samle.dir, "/", file_Us_twitter)
