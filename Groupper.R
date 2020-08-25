library(tidyverse)
library(readxl)

############
rm(list=ls())
############

list_all_files = list.files("Data", full.names = TRUE)

# Fixing dataframes' structure and saving them as csv
for (i in 1:length(list_all_files))
{
  file_i = read_excel(list_all_files[i], skip = 0)

  if (colnames(file_i[1]) != "DATA" && colnames(file_i[1]) != "Data")
  {
    if ((colnames(file_i[1]) == "TIPO" || colnames(file_i[1]) == "Tipo"))
    {
      file.remove(list_all_files[i])
    }
    else if (colnames(file_i[1]) == "...1")
    {
      file_i= select(file_i, -...1)
      names(file_i) = toupper(names(file_i))
      write_csv(file_i, path=paste0("Data/file_", i, ".csv"))
    }
    else
    {
      file_i = read_excel(list_all_files[i], skip = 1)
      names(file_i) = toupper(names(file_i))
      write_csv(file_i, path=paste0("Data/file_", i, ".csv"))
    }
  }
  else
  {
    names(file_i) = toupper(names(file_i))
    write_csv(file_i, path=paste0("Data/file_", i, ".csv"))
  }
  print(paste0("file ", i, "/", length(list_all_files), " is ok"))
  file.remove(list_all_files[i])
}

# Identifying patterns in column names
list_all_files = list.files("Data", full.names = TRUE)
all_names = list()

for (i in 1:length(list_all_files))
{
  file_i = read_csv(list_all_files[i])
  all_names[[paste0("file_", i)]] = colnames(file_i)
  print(paste0("file ", i, " is ok"))
}


all_names = enframe(all_names) %>%
  distinct(value, .keep_all = TRUE)

pattern_1 = paste(unname(unlist(all_names[1, "value"])), collapse = ", ")
pattern_2 = paste(unname(unlist(all_names[2, "value"])), collapse = ", ")
pattern_3 = paste(unname(unlist(all_names[3, "value"])), collapse = ", ")
pattern_4 = paste(unname(unlist(all_names[4, "value"])), collapse = ", ")
pattern_5 = paste(unname(unlist(all_names[5, "value"])), collapse = ", ")

# Fixing column names in dataframes
for (i in 1:length(list_all_files)) 
{
  file_i = read_csv(list_all_files[i])
  name_i = paste(colnames(file_i), collapse = ", ")
  if (name_i == pattern_1)
  {
    file_i = transmute(file_i, DATA, TIPO, AREA, LINHA, PAGANTES_DINHEIRO = `PASSAGEIROS PAGTES EM DINHEIRO`,
                    PAGANTES_BU_E_VT =`PASSAGEIROS COMUM E VT`+`PASSAGEIROS PGTS BU COMUM M`+`PASSAGEIROS PGTS BU VT MENSAL`,
                    PAGANTES_ESTUDANTES = `PASSAGEIROS PAGTES ESTUDANTE`+`PASSAGEIROS PGTS BU EST MENSAL`,
                    TOTAL_ESTUDANTES = `PASSAGEIROS PAGTES ESTUDANTE`+`PASSAGEIROS PGTS BU EST MENSAL`+`PASSAGEIROS COM GRATUIDADE EST`,
                    PASSAGEIROS_PAGANTES = `PASSAGEIROS PAGANTES`,
                    GRATUIDADES_OUTRAS = `PASSAGEIROS COM GRATUIDADE`, INTEGRACAO_ONIBUS = `PASSAGEIROS INT ÔNIBUS->ÔNIBUS`, TOTAL_PASSAGEIROS = `TOT PASSAGEIROS TRANSPORTADOS`)
    write_csv(file_i, path=list_all_files[i])
    print("pattern 1")
  }
  else if (name_i == pattern_2)
  {
    file_i = transmute(file_i, DATA, TIPO, AREA, LINHA, PAGANTES_DINHEIRO = `PASSAGEIROS PAGANTES EM DINHEIRO\n\n(A)`,
                       PAGANTES_BU_E_VT =`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM\n\n(B)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM MENSAL\n\n(C)`
                       +`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE\n\n(F)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE MENSAL\n\n(G)`,
                       PAGANTES_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`,
                       TOTAL_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`+`PASSAGEIROS COM GRATUIDADE ESTUDANTE\n\n(M)`,
                       PASSAGEIROS_PAGANTES = `PASSAGEIROS PAGANTES\n\n(J) = (A+B+C+D+E+F+G+H+I)`,
                       GRATUIDADES_OUTRAS = `PASSAGEIROS COM GRATUIDADE\n\n(L)`, INTEGRACAO_ONIBUS = `PASSAGEIROS INTEGRAÇÕES ÔNIBUS -> ÔNIBUS\n\n(K)`,
                       TOTAL_PASSAGEIROS = `TOTAL PASSAGEIROS TRANSPORTADOS\n\n(N) = (J + K + L + M)`)
    write_csv(file_i, path=list_all_files[i])
    print("pattern 2")
  }
  else if (name_i == pattern_4)
  {
    file_i = transmute(file_i, DATA, TIPO, AREA, LINHA, PAGANTES_DINHEIRO = `PASSAGEIROS PAGTES EM DINHEIRO`,
                       PAGANTES_BU_E_VT =`PASSAGEIROS PAGTES COMUM`+`PASSAGEIROS PGTS BU COMUM M`+`PASSAGEIROS PAGTES BU VT`+`PASSAGEIROS PGTS BU VT MENSAL`,
                       PAGANTES_ESTUDANTES = `PASSAGEIROS PAGTES ESTUDANTE`+`PASSAGEIROS PGTS BU EST MENSAL`,
                       TOTAL_ESTUDANTES = `PASSAGEIROS PAGTES ESTUDANTE`+`PASSAGEIROS PGTS BU EST MENSAL`+`PASSAGEIROS COM GRATUIDADE EST`,
                       PASSAGEIROS_PAGANTES = `PASSAGEIROS PAGANTES`,
                       GRATUIDADES_OUTRAS = `PASSAGEIROS COM GRATUIDADE`, INTEGRACAO_ONIBUS = `PASSAGEIROS INT ÔNIBUS->ÔNIBUS`, TOTAL_PASSAGEIROS = `TOT PASSAGEIROS TRANSPORTADOS`)
    write_csv(file_i, path=list_all_files[i])
    print("pattern 4")
  }
  else if (name_i == pattern_3)
  {
    file_i = transmute(file_i, DATA, TIPO, AREA, LINHA, PAGANTES_DINHEIRO = `PASSAGEIROS PAGANTES EM DINHEIRO\n\n(A)`,
                       PAGANTES_BU_E_VT =`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM\n\n(B)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM MENSAL\n\n(C)`
                       +`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE\n\n(F)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE MENSAL\n\n(G)`,
                       PAGANTES_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`,
                       TOTAL_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`+`PASSAGEIROS COM GRATUIDADE ESTUDANTE\n\n(N)`,
                       PASSAGEIROS_PAGANTES = `PASSAGEIROS PAGANTES\n\n(J) = (A+B+C+D+E+F+G+H+I)`,
                       GRATUIDADES_OUTRAS = `PASSAGEIROS COM GRATUIDADE\n\n(L)`, INTEGRACAO_ONIBUS = `PASSAGEIROS INTEGRAÇÕES ÔNIBUS -> ÔNIBUS\n\n(K)`,
                       TOTAL_PASSAGEIROS = `TOTAL PASSAGEIROS TRANSPORTADOS\n\n(M) = (J + K + L+N)`)
    write_csv(file_i, path=list_all_files[i])
    print("pattern 3")
  }
  else if (name_i == pattern_5)
  {
    file_i = transmute(file_i, DATA, TIPO, AREA, LINHA, PAGANTES_DINHEIRO = `PASSAGEIROS PAGANTES EM DINHEIRO\n\n(A)`,
                                PAGANTES_BU_E_VT =`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM\n\n(B)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO COMUM MENSAL\n\n(C)`
                                +`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE\n\n(F)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO VALE TRANSPORTE MENSAL\n\n(G)`,
                                PAGANTES_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`,
                                TOTAL_ESTUDANTES = `PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE\n\n(D)`+`PASSAGEIROS PAGANTES BILHETE ÚNICO ESTUDANTE MENSAL\n\n(E)`,
                                PASSAGEIROS_PAGANTES = `PASSAGEIROS PAGANTES\n\n(J) = (A+B+C+D+E+F+G+H+I)`,
                                GRATUIDADES_OUTRAS = `PASSAGEIROS COM GRATUIDADE\n\n(L)`, INTEGRACAO_ONIBUS = `PASSAGEIROS INTEGRAÇÕES ÔNIBUS -> ÔNIBUS\n\n(K)`,
                                TOTAL_PASSAGEIROS = `TOTAL PASSAGEIROS TRANSPORTADOS\n\n(M) = (J + K + L)`)
    write_csv(file_i, path=list_all_files[i])
    print("pattern 5")
  }
  else 
  {
      print(paste("file", i, "wasn't changed"))
  }
  print(paste("file", i, "succesfully changed"))
}
