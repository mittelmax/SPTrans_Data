from bs4 import BeautifulSoup
import lxml
import requests
import pandas as pd
import urllib
import ssl
from os import listdir

# data url's
url_2020 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=292723").text
url_2019 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=269652").text
url_2018 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=247850").text
url_2017 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=228269").text
url_2016 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=209427").text
url_2015 = requests.get("https://www.prefeitura.sp.gov.br/cidade/secretarias/transportes/institucional/sptrans/acesso_a_informacao/index.php?p=188767").text


# 2020
soup_2020 = BeautifulSoup(url_2020, "lxml")
links_2020 = [i["href"] for i in soup_2020.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2019
soup_2019 = BeautifulSoup(url_2019, "lxml")
links_2019 = [i["href"] for i in soup_2019.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2018
soup_2018 = BeautifulSoup(url_2018, "lxml")
links_2018 = [i["href"] for i in soup_2018.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2017
soup_2017 = BeautifulSoup(url_2017, "lxml")
links_2017 = [i["href"] for i in soup_2017.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2016
soup_2016 = BeautifulSoup(url_2016, "lxml")
links_2016 = [i["href"] for i in soup_2016.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2015
soup_2015 = BeautifulSoup(url_2015, "lxml")
links_2015 = [i["href"] for i in soup_2015.findAll("a", href=True) if i["href"].endswith(".xls")
              and "Consolidad" not in i["href"] and "Pass_Transp" not in i["href"]]

all_links = links_2020 + links_2019 + links_2018 + links_2017 + links_2016 + links_2015

# # Disabling ssl verification
# try:
#     _create_unverified_https_context = ssl._create_unverified_context
# except AttributeError:
#     pass
# else:
#     ssl._create_default_https_context = _create_unverified_https_context

# Removing spaces and latin-1 characters in url's
for i in range(len(all_links)):
    all_links[i] = all_links[i].replace(" ", "%20")
    all_links[i] = all_links[i].replace("ê", "%C3%AA")

# Scraping data
missing_files = []

for i in range(len(all_links)):
    try:
        file_i, header_i = urllib.request.urlretrieve(all_links[i], "Data/file_{}.xls".format(i+1))
        print("file {} succesfully downloaded".format(i+1))
    except:
        print("There was a problem with file {}".format(i+1))
        missing_files.append("file_{}".format(i+1))

print(missing_files)

# Since only 2 days are missing (file 1613 and file 1265) we can make them equal to the previous day
df_1613 = pd.read_excel("Data/file_1612.xls")
df_1613["DATA"].replace({pd.to_datetime("2016-10-20 00:00:00"):pd.to_datetime("2016-10-21 00:00:00")}, inplace=True)

df_1265 = pd.read_excel("Data/file_1264.xls")
df_1265["Data"].replace({pd.to_datetime("2017-11-07 00:00:00"):pd.to_datetime("2017-11-08 00:00:00")}, inplace=True)

df_1613.to_excel("Data/file_1613.xls")
df_1265.to_excel("Data/file_1265.xls")
