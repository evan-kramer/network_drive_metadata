# Network Drive Metadata
# Evan Kramer

library(tidyverse); library(lubridate); library(readxl)
t1 = now()
file_list = list.files("X:/ACGR", recursive = T)
d = now() - t1
print(d)
data = map(
  .x = str_c("X:/ACGR/", file_list)[1:100],
  .f = ~file.info(str_c("X:/ACGR/"), .x)
) 

  


