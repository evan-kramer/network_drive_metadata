# Network Drive Metadata
# Evan Kramer

# Set up
library(tidyverse); library(lubridate); library(readxl); library(curl)
setwd("X:/Analysis Team/Development/X Drive Crawl/X-Files/temp")

# Get list of all files with timestamp
t1 = now()
file_list = list.files("X:/ACGR", recursive = T)
d1 = str_remove(difftime(now(), t1, units = "mins"), "Time") %>% 
  as.numeric() %>% 
  round(2)

# Get metadata for all files with timestamp
t2 = now()
data = map(
  .x = str_c("X:/ACGR/", file_list)[10],
  .f = ~tibble(file = .x, size = file.size(.x), isdir = file.info(.x)$isdir, 
               ctime = file.info(.x)$ctime, mtime = file.mtime(.x), 
               timestamp = now())
) 
file_info = tibble()
for(i in 1:length(data)) {
  file_info = bind_rows(file_info, data[[i]])
}
d2 = str_remove(difftime(now(), t2, units = "mins"), "Time") %>% 
  as.numeric() %>% 
  round(2)

# Output file
write_csv("network_drive_metadata.csv", na = "")

# Email confirmation
m = 'From: evan.kramer@dc.gov
To: evan.kramer@dc.gov
Subject: SUCCESS: Network Drive Metadata

The network_drive_metadata.R script ran successfully.
It took d1 minutes to inventory all files.
It took d2 minutes to get metadata for all files.'

# Send email with error or run script
send_mail(
  mail_from = readRegistry("Environment", hive = "HCU")$api_uid,
  mail_rcpt = 'anthonys.graham@dc.gov',
  message = str_replace(m, "d1", as.character(d1)) %>% 
    str_replace("d2", as.character(d2)),
  smtp_server = "smtp://smtp.office365.com:587",
  username = readRegistry("Environment", hive = "HCU")$api_uid,
  password = readRegistry("Environment", hive = "HCU")$qb_api_pwd,
  use_ssl = "force"
)