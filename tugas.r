# NAMA : Reza Hartono
# NIM : 053126003
# PRODI : FST - Sistem Informasi

# TUGAS 2 - Analisis dan Visualisasi Data

# Install & Load Package yang dibutuhkan
if (!require("openxlsx")) install.packages("openxlsx")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("dplyr")) install.packages("dplyr")
if (!require("broom")) install.packages("broom")
if (!require("ggpubr")) install.packages("ggpubr")

library(ggplot2)
library(dplyr)
library(broom)
library(ggpubr)
library(openxlsx)

# import data dari excel
data <- read.xlsx("data-tugas.xlsx", sheet = 1, startRow = 2)

# Konversi kolom pendapatan dan kebahagiaan menjadi numerik
data$pendapatan  <- as.numeric(data$pendapatan)
data$kebahagiaan <- as.numeric(data$kebahagiaan)

# Kalikan kolom pendapatan nilai dengan 10.000
data$pendapatan <- data$pendapatan * 10000

# Tampilkan datanya
print(data)

# A. Histogram untuk cek distribusi variabel terikat (kebahagiaan)
ggplot(data, aes(x = kebahagiaan)) +
  geom_histogram(aes(y = after_stat(density)), bins = 20, fill = "#aed9e0", color = "white") +
  geom_density(color = "#0077b6", linewidth = 1) +
  labs(
    title = "Histogram Distribusi Kebahagiaan",
    x = "Kebahagiaan (Variabel Terikat)",
    y = "Density"
  ) +
  theme_minimal()

# B. Scatter Plot antara variabel bebas (pendapatan) dan terikat (kebahagiaan)
ggplot(data, aes(x = pendapatan, y = kebahagiaan)) +
  geom_point(color = "#4682b4", alpha = 0.7) +
  labs(
    title = "Scatter Plot Pendapatan vs Kebahagiaan",
    x = "Pendapatan (Dikali 10.000)",
    y = "Kebahagiaan"
  ) +
  theme_minimal()

# C. Melakukan Regresi Linear Sederhana
model_regresi <- lm(kebahagiaan ~ pendapatan, data = data)
summary(model_regresi)

# D. Cek asumsi homoskedastisitas (Residuals vs Fitted)
par(mfrow = c(1, 1))
plot(model_regresi, which = 1)

# E. Visualisasi Hasil Regresi dengan ggpubr
ggscatter(data, x = "pendapatan", y = "kebahagiaan",
          add = "reg.line", 
          add.params = list(color = "red", size = 1),
          conf.int = TRUE,
          color = "#2b5c8f", 
          alpha = 0.6) +
  stat_regline_equation(label.x = 16000, label.y = 6.2, size = 4.5) +
  labs(
    title = "Regresi Linear Sederhana: Kebahagiaan vs Pendapatan",
    x = "Pendapatan (Nilai Asli x 10.000)",
    y = "Tingkat Kebahagiaan"
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 13),
    axis.title = element_text(face = "bold", size = 10)
  )