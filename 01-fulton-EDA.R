# Base de datos -----
dbT   <- readxl::read_excel("BD.xlsx", 
                            sheet = "BDT")
# Recodificacion ----
require(data.table)
df    <- data.table(dbT, 
                    stringsAsFactors = T)
df$ID <- as.character(df$ID)
# EDA (Exploratory Data Analysis) 
### Peso y Medidas (Crudas y log) 
# Ajuste visualizacion ----
op <- par(mfcol= c (2,2), 
          mar = c(4,4,2,2))
# BP-Cumulativos
boxplot(df[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "Medidas", 
        main = "", 
        horizontal = T, 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# BP-log-Cum 
boxplot(df[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "log Medidas", 
        main = "",  
        horizontal = T,  
        log = "x", 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# CP-Cumulativo
dotchart(df$Peso[!is.na(df$Peso)], 
         bg = "black", 
         pt.cex = 1.5, 
         labels = df$ID[!is.na(df$ID)], 
         lcolor = "gray", 
         cex = 0.6, 
         xlab = "Peso (kg)", 
         ylab = "")
# CP-log-Cum 
dotchart(log(df$Peso[!is.na(df$Peso)]), 
         bg = "black", 
         pt.cex = 1.5, 
         labels = df$ID[!is.na(df$ID)], 
         lcolor = "gray", 
         cex = 0.6, 
         xlab = "log Peso (kg)", 
         ylab = "")
# Crudas por sexo ----
require(data.table)
H   <- df[Sexo == "H"]
M   <- df[Sexo == "M"]
# BP-Hembras 
boxplot(H[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "Hembras", 
        main = "", 
        horizontal = T, 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# BP-Machos 
boxplot(M[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "Machos", 
        main = "", 
        horizontal = T, 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# CP-Hembras
dotchart(H$Peso[!is.na(H$Peso)], 
         bg = "black", 
         pt.cex = 1.5, 
         labels = H$ID, 
         lcolor = "gray", 
         cex = 0.7, 
         xlab = "Peso (kg)", 
         ylab = "")
# CP-Machos 
dotchart(M$Peso[!is.na(M$Peso)], 
         bg = "black", 
         pt.cex = 1.5, 
         labels = M$ID[!is.na(M$ID)], 
         lcolor = "gray", 
         cex = 0.7, 
         xlab = "Peso (kg)", 
         ylab = "")
# Log por sexo ----
# BP-logHembras 
boxplot(H[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "log Hembras", 
        main = "",  
        horizontal = T,  
        log = "x", 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# BP-logMachos 
boxplot(M[,10:16], 
        col = "lightgray",
        ylab = "", 
        xlab = "log Machos", 
        main = "",  
        horizontal = T,  
        log = "x", 
        cex.axis = 0.8, 
        cex.lab = 0.8)
# CP-logHembras 
dotchart(log(H$Peso[!is.na(H$Peso)]), 
         bg = "black", 
         pt.cex = 1.5, 
         labels = H$ID[!is.na(H$ID)], 
         lcolor = "gray", 
         cex = 0.7, 
         xlab = "log Peso (kg)", 
         ylab = "")
# CP-logMachos 
dotchart(log(M$Peso[!is.na(M$Peso)]), 
         bg = "black", 
         pt.cex = 1.5, 
         labels = M$ID[!is.na(M$ID)], 
         lcolor = "gray", 
         cex = 0.7, 
         xlab = "log Peso (kg)", 
         ylab = "")
# Resetear ajustes de visualizacion ----
par(op)

### Multi-panel Cleveland dot plot----
# Variables con logaritmos base 10 (log10) ----
require(dplyr)
# Cumulativo 
K <- df  %>%   
  mutate(logW    =log10(Peso),
         logLTC  =log10(LTC),
         logCCu  =log10(CCu),
         logCPCH =log10(CPCH),
         logCCL  =log10(CCL),
         logLHC  =log10(LHC), 
         logLT   =log10(LT))
# Hembras 
KH <- H  %>%   
  mutate(logW    =log10(Peso),
         logLTC  =log10(LTC),
         logCCu  =log10(CCu),
         logCPCH =log10(CPCH),
         logCCL  =log10(CCL),
         logLHC  =log10(LHC), 
         logLT   =log10(LT))
# Machos
KM <- M  %>%   
  mutate(logW    =log10(Peso),
         logLTC  =log10(LTC),
         logCCu  =log10(CCu),
         logCPCH =log10(CPCH),
         logCCL  =log10(CCL),
         logLHC  =log10(LHC), 
         logLT   =log10(LT))

# Cleveland dot plot ----
require(lattice)
# Variables crudas ----
Z <- cbind(df$LTC, 
           df$CCu,  
           df$CPCH,
           df$CCL,  
           df$LHC, 
           df$LT)
# Colnames
colnames(Z) <- c("Longitud de Cráneo", "Circunferencia de Cuello", "Circunferencia de Pecho","Circunferencia de Cola", "Longitud Hocico - Cloaca", "Longitud Total")
# Dotplot 
dotplot(as.matrix(Z), 
        groups = FALSE,
        strip = 
          strip.custom(bg = 'grey',
                             par.strip.text = list(cex = 0.8)),
        scales = list(x = list(relation = "sliced"),
                      y = list(relation = "sliced"),
                      draw = F),
        col = 1, cex  = 0.8, pch = 19,
        xlab = "Medidas en cm",
        ylab = "")

# Variables log ---- 
Y <- cbind(K$logW, 
           K$logCCu,  
           K$logCPCH,
           K$logCCL,  
           K$logLHC, 
           K$logLT)
# Colnames log 
colnames(Y) <- c("Log Cráneo", "Log Cuello", "Log Pecho","Log Cola", "Log Hocico - Cloaca", "Log Longitud Total")
# Dotplot log 
dotplot(as.matrix(Y), 
        groups = FALSE,
        strip = 
          strip.custom(bg = 'grey',
                       par.strip.text = list(cex = 0.8)),
        scales = list(x = list(relation = "sliced"),
                      y = list(relation = "sliced"),
                      draw = F),
        col = 1, cex  = 0.8, pch = 19,
        xlab = "Log Medidas Sin distinción de sexo",
        ylab = "")

# Variables log por sexo ----
# Machos
Mc <- cbind(KM$logW, 
            KM$logCCu,  
            KM$logCPCH,
            KM$logCCL,  
            KM$logLHC, 
            KM$logLT)
# Colnames log 
colnames(Mc) <- c("Log Cráneo", "Log Cuello", "Log Pecho","Log Cola", "Log Hocico - Cloaca", "Log Longitud Total")
# Dotplot log 
dotplot(as.matrix(Mc), 
        groups = FALSE,
        strip = 
          strip.custom(bg = 'grey',
                       par.strip.text = list(cex = 0.8)),
        scales = list(x = list(relation = "sliced"),
                      y = list(relation = "sliced"),
                      draw = F),
        col = 1, cex  = 0.8, pch = 19,
        xlab = "Log Medidas Machos",
        ylab = "")
# Hembras
Hc <- cbind(KH$logW, 
            KH$logCCu,  
            KH$logCPCH,
            KH$logCCL,  
            KH$logLHC, 
            KH$logLT)
# Colnames log 
colnames(Hc) <- c("Log Cráneo", "Log Cuello", "Log Pecho","Log Cola", "Log Hocico - Cloaca", "Log Longitud Total")
# Dotplot log 
dotplot(as.matrix(Hc), 
        groups = FALSE,
        strip = 
          strip.custom(bg = 'grey',
                       par.strip.text = list(cex = 0.8)),
        scales = list(x = list(relation = "sliced"),
                      y = list(relation = "sliced"),
                      draw = F),
        col = 1, cex  = 0.8, pch = 19,
        xlab = "Log Medidas Hembras",
        ylab = "")
