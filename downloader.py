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
links_2020 = [i["href"] for i in soup_2020.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2019
soup_2019 = BeautifulSoup(url_2019, "lxml")
links_2019 = [i["href"] for i in soup_2019.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2018
soup_2018 = BeautifulSoup(url_2018, "lxml")
links_2018 = [i["href"] for i in soup_2018.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2017
soup_2017 = BeautifulSoup(url_2017, "lxml")
links_2017 = [i["href"] for i in soup_2017.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2016
soup_2016 = BeautifulSoup(url_2016, "lxml")
links_2016 = [i["href"] for i in soup_2016.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

# 2015
soup_2015 = BeautifulSoup(url_2015, "lxml")
links_2015 = [i["href"] for i in soup_2015.findAll("a", href=True) if i["href"].endswith(".xls") and "Consolidado" not in i["href"] and "Pass_Transp" not in i["href"]]

all_links = links_2020 + links_2019 + links_2018 + links_2017 + links_2016 + links_2015

# Desabilitando verificação de ssl
try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    pass
else:
    ssl._create_default_https_context = _create_unverified_https_context

# Removendo links com espaços
for i in range(len(all_links)):
    all_links[i] = all_links[i].replace(" ", "%20")
    all_links[i] = all_links[i].replace("ê", "%C3%AA")

# Baixando dados
df = pd.DataFrame()

missing_files = []

for i in range(len(all_links)):
    try:
        file_i, header_i = urllib.request.urlretrieve(all_links[i], "Data/file_{}.xls".format(i+1))
        print("file {} succesfully downloaded".format(i+1))
    except:
        print("There was a problem with file {}".format(i+1))
        missing_files.append("file_{}".format(i+1))

print(missing_files)

# Como faltaram arquivos de apenas 2 dias (1615 e 1267) podemos igualar tais datas ao dia anterior
df_1615 = pd.read_excel("Data/file_1614.xls")
df_1267 = pd.read_excel("Data/file_1266.xls")

df_1615.to_excel("Data/file_1615.xls")
df_1267.to_excel("Data/file_1267.xls")
