
# --------------------------------------------------------------------------------------------------
# Ogr. Gor. Dr. Musa SADAK tarafindan verilen Istatistik Egitimi kapsaminda kullanilan R Script'idir
#                               Musa SADAK 2021(c)
# Burada yer alan icerik Creative Commons Lisanslama 4.0 (cc) ile lisanslanmistir
#                                 CC BY-NC-ND
# Ticari veya ticari olmayan sekilde orijinal veya degistirilmis haliyle yayinlanamaz
# Kullanimi ve paylasimi sadece eser sahibine bildirilerek ve alintilayarak yapilabilir
# --------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------
#                    R ile Hiyerarsik Lineer Modelleme (HLM)
# --------------------------------------------------------------------------------------------------



# -----------------------------------------------------------------------
# Ilk olarak bilgisayarimiza working directory olusturacagiz. 
# Yani kullanacagimiz ve kaydedecegimiz dosyalar icin yer belirtecegiz.

# getwd()
# Bu komut bize bilgisayarimizin working directory sini verecek. Simdi bunu istedigimiz sekilde degistirelim.

# Benim bilgisayarimda masaustune "/Users/musasadak/Desktop/DATA" klasorune almak istiyorum
# setwd()

# -----------------------------------------------------------------------------------------------------------
#                                                       NOT
# Burada mac ve windows bilgisayarlar icin farkli sekilde olabilir. Windows bilgisayarlarda / yerine \\ olabilir
# Klasore sag tiklayip dosya dizinini (folder path) elde ettigimizde buraya yapistirabiliriz. 
# setwd("C:/folder path here")
# -----------------------------------------------------------------------------------------------------------






# -----------------------------------------------------------------------------------------------------------
# Simdi de spss dosyamizi R ortamina aktaracagiz. Istersek Rabia Hocanin da gosterdigi gibi .xlsx veya .txt
# uzantili dosyalarimizla da calisabiliriz. Onlari zaten gordugumuz icin ve genelde uluslararasi veriler SPSS
# formatinda verildigi icin SPSS veri setinin nasil buraya aktarildigini gostermek istedim.

# spss.get komutunu calistiralim

# Bu fonksiyonu kullanmak istedigimizde bize uyari verecek gerekli paketin yuklu olmadigina dair.
# Elbette bu fonksiyonun hangi paket ve kutuphanede oldugunu biliyorum ancak bilmediginiz durumlar olabilecegi icin
# ornek bir senaryo olusturmak istedim.
# -----------------------------------------------------------------------------------------------------------





# -----------------------------------------------------------------------------------------------------------
# Internetten spss.get seklinde arattigimizda spss.get function olarak arama sonuclarinda karsimiza cikacaktir.
# foreign ve Hmisc paket ve kutuphanelerini yuklemeliyiz

# install.packages("foreign") 
# library(foreign)
# install.packages("Hmisc")
# library(Hmisc)
# -----------------------------------------------------------------------------------------------------------




# -----------------------------------------------------------------------------------------------------------
# Simdi spss.get kullanabiliriz. 
#   "<-" icin 
#         "Option & -" Mac, 
#         "Alt & -" Windows)

# mydata <- spss.get("Out.sav", use.value.labels = FALSE,)

# ?spss.get dersek hangi komutlarin oldugunu gorebiliriz 
# use.value.labels adindan da anlasilacagi uzere, spss deki degiskenlerimizin orjinal formatinda mi yoksa 
# etiketlenmis formatinda mi gorecegimizi belirtir. Yani ister 792 isterse Turkiye olarak veriyi okuyabiliriz
# Ancak burada elbette sayisal olarak okumak mantikli. O yuzden FALSE diyoruz.

# sonuna virgul koydugumuzda kalan butun komutlarin default calismasini saglariz. Cogu durumda zaten boyle yapacaktir
# Ancak yine de yapmak da fayda var
# -----------------------------------------------------------------------------------------------------------







# -----------------------------------------------------------------------------------------------------------
# Simdi de yukledigimiz veriye goz atalim

# names(mydata)
# summary(mydata)
# nrow(mydata)
# ncol(mydata)
# head(mydata)
# tail(mydata)

# Soyle ozel komutlar da verebiliriz
# summary(mydata$ITLANG)
# -----------------------------------------------------------------------------------------------------------






# -----------------------------------------------------------------------------------------------------------
# Simdi de verimizin descriptive (betimleyici?) istatistiklerine goz atalim

# Oncelikle psych paketine ihtiyacimiz var
# install.packages("psych")
# library(psych)

# describe(mydata, skew = FALSE)
# describe(mydata, skew = TRUE)
# Burada skew TRUE olunca skewness ve kurtosis degerlerini de hesaplayacaktir.
# -----------------------------------------------------------------------------------------------------------







# -----------------------------------------------------------------------------------------------------------
# Bir de describe fonksiyonunu Hmisc paketinden kullanalim

# Hmisc::describe(mydata)
# psych::describe(mydata)
# -----------------------------------------------------------------------------------------------------------







#-----------------------------------------
#                Gelelim HLM'e
#-----------------------------------------

# Package ve library yi yukleyelim
# install.packages("nlme")
# library(lme4)


# Simdi de teorik olarak olusturdugumuz modelleri burada kendi verimiz uzerinde test edelim

#-----------------------------------------
#         Ilk olarak bos modelimiz
# MAT = intercept + ogretmen res. + ogrenci res.
#       M0 <- lmer(BSMMAT01~(1|IDTEACH), data = mydata)
#       summary(M0)
#       ICC1 <- .. / (.. + ..)
#-----------------------------------------


# Bu da oylesine sacma bi bos model :)

M00 <- lmer(BSMMAT01~(1|IDBOOK), data = mydata)
summary(M00)
ICC2 <- . / (. + .)


#----------------------------------------------------------------------------------
#                             Simdi de esas modelimiz
#      MAT = Ogrenci gender + Ogretmen Gender + Ogretmen etkilesim + RESIDUALS
# StGen: ITSEX, BSBG01;  TcGen: BTBG02; TcIn: Mean Variable
#   M1 <- lmer(BSMMAT01 ~ ITSEX + BTBG02 + BTBG09 + (1|IDTEACH), data=mydata, REML=FALSE)
# REML: Restricted Maximum Likelihood, When  having random effects
# O yuzden bizde hepsi fixed oldugundan REML = FALSE. Yine de ikisini karsilastirip bakmak gerek 
#----------------------------------------------------------------------------------



#----------------------------------------------------------------------------------
#                 Simdi de bazi degiskenlerin effectini (etkisini) test edelim
#  Ornegin BTBG09 degiskeni olmasaydi acaba daha iyi bir model uyumu yakalayabilir miydik?
#  M2 <- lmer(BSMMAT01 ~ ITSEX + BTBG02 + (1|IDTEACH), data=mydata, REML=FALSE)

# AIC ve BIC degerlerini karsilastirarak bunu saglayabiliriz
# AIC(M1)
# AIC(M2)
# BIC(M1)
# BIC(M2)

# Bu degerlerin dusuk olmasi modelimnizin veriye daha iyi uyum gosterdigini belirtir.
# (Best model-fit)
# Iki model arasindaki BIC farkinin ne derece kanit gosterigi icin Raftery (1995) calismasina bakiniz
#----------------------------------------------------------------------------------




#----------------------------------------------------------------------------------
#  Ornegin BTBG09 degiskeni random olsaydi acaba daha iyi bir model uyumu yakalayabilir miydik?
#  M3 <- lmer(BSMMAT01 ~ ITSEX + BTBG02 + BTBG09 + (BTBG09|IDTEACH), data=mydata, REML=FALSE)
#  summary(M3)
# BTBG09 u random olarak belirledik yani her bir ogretmen icin bunun katsayisini degisebilir kildik

# Simdi olusturdugumuz modelde katsayilar nasil sekilleniyor ona bakalim
# coef(M3)
# Eski modelimizin katsayilarina da bakalim
# coef(M1)
# Burada goruldugu uzere her bir ogretmenin sinifi icin BTBG09 degiskeninin katsayisi farklilik gostermekte artik

# Yine modelleri karsilastiralim
# Elbette mantikli olarak M1 ve M3 modellerini kiyaslayacagiz
# AIC(M1)
# AIC(M3)
# BIC(M1)
# BIC(M3)
#----------------------------------------------------------------------------------







#----------------------------------------------------------------------------------
# Son olarak da interaction (etkilesim) modeli olusturalim
# Yani sectigimiz herhangi iki degiskenin birbiryle etkilesim yapabilmesine musade edelim

# M4 <- lmer(BSMMAT01 ~ ITSEX + BTBG02 + BTBG09 + BTBG02*BTBG09 + (1|IDTEACH), data=mydata, REML=FALSE)
# Literatur bize ogretmenlerin etkilesimlerinin cinsiyetle baglantili oldugunu soyluyordur. O yuzden
# boyle bir etkilesime musade etmek istiyoruz demektir. Ancak eger yeni model daha iyi uyum gostermezse
# bizim sample imizda bu durumun olmadigini soyleyebiliriz

# Bu sefer de M1 ve M4 modellerini karsilastiracagiz
# AIC(M1)
# AIC(M4)
# BIC(M1)
# BIC(M4)
#----------------------------------------------------------------------------------





#----------------------------------------------------------------------------------
# Hatta en sonunda hepsine bakabiliriz :)
# AIC(M0)
# AIC(M1)
# AIC(M2)
# AIC(M3)
# AIC(M4)

# BIC(M0)
# BIC(M1)
# BIC(M2)
# BIC(M3)
# BIC(M4)
# ---------------------------------------------------------------------------------







#----------------------------------------------------------------------------------
# Simdi de R2 (R-squared) dedigimiz variance explained durumunu inceleyelim
# R2 demek bizim modelimizin cikti degiskeni olan matematik basarisindaki degisilebilirligin (varyansin)
# yuzde kacini ongorebildigi veya aciklayabildigidir (explained-variance)

# Bunun icin MuMIn paketini yuklememiz gerekiyor :)   (I buyuk)
# install.packages("MuMIn")
# library(MuMIn)

# ?r.squaredGLMM
# ?r.squaredLR
# Burada conditional olani yani c yi alacagiz. Cunku bu bize tum modelin R^2 ini verecek
# Burada LR pseudo verdigi icin ben GLMM i tercih ediyorum
# ---------------------------------------------------------------------------------




#----------------------------------------------------------------------------------
# Son olarak da ornek teskil etmesi acisindan Tezimde kullandigim scriptlerden biri olan DissertationCleanData yi
# paylasabilirim. Burada HLM icin ozel bir paket olan BIFIE.survey paketini kullanmistim
#----------------------------------------------------------------------------------



#----------------------------------------------------------------------------------
#                               TESEKKURLER
#----------------------------------------------------------------------------------

