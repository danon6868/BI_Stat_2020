setwd('/home/danil/bioinf_institute/statistics/projects/BI_Stat_2020/project_mouse/')
library(readxl)
library(ggplot2)
library(dplyr)
library(car)
library(multcomp)
library(GGally)
library(corrplot)
library(ggcorrplot)
library(vegan)
library(factoextra)
library(scatterplot3d)
library(rgl)
theme_set(theme_bw())
mouse_data <- read_xls('Data/Data_Cortex_Nuclear.xls')
str(mouse_data)

# 1. Описание данных и причесывание


# Небольшая функция, для создания новой переменной id. В исходных данных значения этой переменной имеют вид xxx_[1 - 15],
# то есть id также несет информацию о технической повторности, для дальнейшей группировки данных необходимо
# оставить только информацию только об id. 

make_id <- function(data){
  f <- function(x){
    list_of_letters <- strsplit(x, '')
    under_index <- which(list_of_letters[[1]] == '_')
    return(substr(x, 1, under_index - 1))
  }
  ids <- unlist(lapply(data, f))
  return(ids)
}

mouse_data$id <- make_id(mouse_data$MouseID)

mouse_quantity <- length(unique(mouse_data$id))

# Всего 72 мыши в эксперименте

mouse_data$Genotype <- as.factor(mouse_data$Genotype)
mouse_data$Treatment <- as.factor(mouse_data$Treatment)
mouse_data$Behavior <- as.factor(mouse_data$Behavior)
mouse_data$class <- as.factor(mouse_data$class)

classes <- levels(mouse_data$class)

# Всего 8 групп (по переменной class)

class_pivot_count <- mouse_data %>%
                      group_by(class) %>% 
                      summarise(count = n() / 15)
treat_pivot_count <- mouse_data %>%
                     group_by(Treatment) %>% 
                     summarise(count = n() / 15)

genotype_pivot_count <- mouse_data %>%
                        group_by(Genotype) %>% 
                        summarise(count = n() / 15)

behavior_pivot_count <- mouse_data %>%
                        group_by(Behavior) %>% 
                        summarise(count = n() / 15)
# Функция для отрисовки барплотов распределения числа мышей по группам
group_distr_col <- function(data, x, y = 'count'){
  ggplot(data, aes(x = list(data[x][[1]])[[1]], y = list(data[y][[1]])[[1]])) +
    geom_col(fill = '#FDC65E') +
    #scale_y_continuous(breaks = c(0, 2, 4, 6, 8, 10)) +
    theme(plot.title = element_text(hjust = 0.5)) + 
    xlab(paste0('Группы по переменной ', x)) + 
    ylab('Количество мышей') +
    ggtitle('Распределение числа мышей по переменной class') 
}

group_distr_col(class_pivot_count, 'class')
group_distr_col(behavior_pivot_count, 'Behavior')
group_distr_col(treat_pivot_count, 'Treatment')
group_distr_col(genotype_pivot_count, 'Genotype')


# Виден некоторый дисбаланс классов, особенно в сторону контрольной группы

na_quant <- sum(is.na(mouse_data))
na_data <- apply(apply(mouse_data, 2, is.na), 2, sum)

# 
classes

c_CS_m <- mouse_data[mouse_data$class == 'c-CS-m', ][, 2:78]
c_CS_s <- mouse_data[mouse_data$class == 'c-CS-s', ][, 2:78]
c_SC_m <- mouse_data[mouse_data$class == 'c-SC-m', ][, 2:78]
c_SC_s <- mouse_data[mouse_data$class == 'c-SC-s', ][, 2:78]
t_CS_m <- mouse_data[mouse_data$class == 't-CS-m', ][, 2:78]
t_CS_s <- mouse_data[mouse_data$class == 't-CS-s', ][, 2:78]
t_SC_m <- mouse_data[mouse_data$class == 't-SC-m', ][, 2:78]
t_SC_s <- mouse_data[mouse_data$class == 't-SC-s', ][, 2:78]


pivot_na_data <- data.frame(class = classes, 
                            rbind(apply(apply(c_CS_m, 2, is.na), 2, sum),
                                        apply(apply(c_CS_s, 2, is.na), 2, sum),
                                        apply(apply(c_SC_m, 2, is.na), 2, sum),
                                        apply(apply(c_SC_s, 2, is.na), 2, sum),
                                        apply(apply(t_CS_m, 2, is.na), 2, sum),
                                        apply(apply(t_CS_s, 2, is.na), 2, sum),
                                        apply(apply(t_SC_m, 2, is.na), 2, sum),))

top_genes <- rev(names(sort.int(na_data)[78:83]))
pivot_na_data[, c('class', top_genes)]

# Так как довольно много пропущенных значений, я заменю их на среднее по группам (переменная class)

na_2_mean <- function(df){
for (cols in colnames(df)) {
  if (cols %in% names(df[,sapply(df, is.numeric)])) {
    df <- df %>% mutate(!!cols := replace(!!rlang::sym(cols), is.na(!!rlang::sym(cols)), mean(!!rlang::sym(cols), na.rm=TRUE)))
  }
  else {
    
    df<-df%>%mutate(!!cols := replace(!!rlang::sym(cols), !!rlang::sym(cols)=="", getmode(!!rlang::sym(cols))))
  }
}
 return(df) 
}

mouse_data_wo_na <- cbind(mouse_data$MouseID,
                           mouse_data$id,
                           mouse_data$class,
                           mouse_data$Behavior,
                           mouse_data$Treatment,
                           mouse_data$Genotype,
                           rbind(na_2_mean(c_CS_m),
                           na_2_mean(c_CS_s),
                           na_2_mean(c_SC_m),
                           na_2_mean(c_SC_s),
                           na_2_mean(t_CS_m),
                           na_2_mean(t_CS_s),
                           na_2_mean(t_SC_m),
                           na_2_mean(t_SC_s)))

colnames(mouse_data_wo_na)[1:6] <- c('MouseID',
                                     'id',
                                     'class',
                                     'Behavior',
                                     'Treatment',
                                     'Genotype')

# Проверка, что NA заменились действительно на средние именно про группам (class)

na_2_mean(c_CS_s)[is.na(c_CS_s$H3MeK4_N), ]$H3MeK4_N
mean(c_CS_s$H3MeK4_N, na.rm = T)

# Выглядит неплохо, значит проблемы в данных исправлены, можно продолжать анализ

# 2. Есть ли различия в уровне продукции BDNF_N в зависимости от класса в
# эксперименте?

str(mouse_data_wo_na)
mouse_data_wo_na$BDNF_N

# Для начала попробую дисперсионный анализ

bdnf_mod <- lm(BDNF_N ~ class, data = mouse_data_wo_na)
av_bdn_mod <- Anova(bdnf_mod)
av_bdn_mod

# Видим, что класс является значимым предиктором
# Прежде чем делать пост-хоки и выводы проверим условия применимости

bdnf_mod_diag <- fortify(bdnf_mod)
bdnf_mod_diag

# Расстояния Кука

ggplot(bdnf_mod_diag, aes(x = 1:nrow(bdnf_mod_diag), y = .cooksd)) +
  geom_bar(stat = 'identity') +
  xlab('Номер наблюдения') + 
  ylab('Расстояние Кука') +
  ggtitle('График расстояний Кука') +
  theme(plot.title = element_text(hjust = 0.5))

# Графики остатков

ggplot(data = bdnf_mod_diag, aes(x = .fitted, y = .stdresid)) + 
  geom_point() + 
  geom_hline(yintercept = 0) +
  geom_smooth(method = "lm") +
  geom_hline(yintercept = 2, color = "red") +
  geom_hline(yintercept = -2, color = "red") +
  xlab('Предсказанное значение') + 
  ylab('Стандартизованные остатки')

ggplot(bdnf_mod_diag, aes(x = class, y = .stdresid)) +
  geom_boxplot() + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Класс') + 
  ylab('Стандартизованные остатки') +
  ggtitle('Распределение стандартизованных остатков модели\nпо классу')

# Графики остатков показывают, что есть довольно много плохо предсказанных значений, но особого паттерна не наблюдается, также
# медианное значение остатков в разных классах примерно одинаково назодится близко к нулю

# Нормальность распределения остатков

qqPlot(bdnf_mod, xlab = 'Квантили нормального распределения', ylab = 'Квантили распределения остатков модели')
shapiro.test(bdnf_mod_diag$.resid)

# Несмотря на то, что мы не можем назвать распределение остатков модели нормальным, 
# мы вполне можем попробовать применить дисперсионный анализ, так как qqqplot выглядит неплохо и другие условия
# применимости в целом не нарушены


res_tukey <- glht(bdnf_mod, linfct = mcp(class = 'Tukey'))
summary(res_tukey)

# Визуализация пост=хок тестов

data <-  expand.grid(class = mouse_data_wo_na$class)
data <- data.frame(data,
                   predict(bdnf_mod, newdata = data, interval = 'confidence'))
pos <- position_dodge(width = 0.2)
gg_linep <- ggplot(data, aes(x = class, y = fit,
                             ymin = lwr, ymax = upr)) + 
  geom_point(position = pos) +
  geom_errorbar(position = pos, width = 0.2) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Класс') + 
  ylab('Предсказанное среднее значение') +
  ggtitle('Зависимость предсказанной\nсредней экспрессии BDNF_N от класса')
gg_linep


# Видно, что есть значимая зависимость продукции BDNF_N от класса в эксперименте


# 3. Попробовать построить линейную модель, способную предсказать уровень
# продукции белка ERBB4_N на основании данных о других белках в эксперименте


exp_data <- mouse_data_wo_na[, -c(1:6)]
ggcorr(exp_data, hjust = 0.75, size = 1.5, color = "black", layout.exp = 1)

# Судя по данному хит-мапу можем ожидать наличие мультиколлинеарности в данных, но это еще придется проверить

# Строим полную линейную модель для белка ERBB4_N

erbb_mod <- lm(ERBB4_N ~ ., data = exp_data)
summary(erbb_mod)

# Проведем диагностику это модели

erbb_mod_diag <- fortify(erbb_mod)

# График остатков Кука
# Нет влиятельных наблюдений

ggplot(erbb_mod_diag, aes(x = 1:nrow(erbb_mod_diag), y = .cooksd)) +
  geom_bar(stat = 'identity') +
  xlab('Номер наблюдения') + 
  ylab('Расстояние Кука') +
  ggtitle('График расстояний Кука') +
  theme(plot.title = element_text(hjust = 0.5))

# График остатков

ggplot(data = erbb_mod_diag, aes(x = .fitted, y = .stdresid)) + 
  geom_point() + 
  geom_hline(yintercept = 0) +
  geom_smooth(method = "lm") +
  geom_hline(yintercept = 2, color = "red") +
  geom_hline(yintercept = -2, color = "red") +
  xlab('Предсказанное значение') + 
  ylab('Стандартизованные остатки') + 
  ggtitle('График зависимости остатков модели\nот предсказанного значения') + 
  theme(plot.title = element_text(hjust = 0.5))

# Остатки имеют выраженный паттерн, а также много наблюдений отстают более чем на 2
# стандартных отклонения

# Нормальность распределения остатков

qqPlot(erbb_mod)
shapiro.test(erbb_mod_diag$.stdresid)

# Распределения стандартизованных остатков значимо не отличается от нормального

# Проверка на мультикомллинеарность
# Мультиколлинеарность скорее всего имеется, это ясно и с точки зрения биологии и из корреляционной матрицы, которая была выше
# Проверим это более детально при помощи рассчета VIF

vif(erbb_mod)


alias(erbb_mod)


erbb_mod <- lm(ERBB4_N ~ . -ARC_N, data = exp_data)

erbb_mod

vif(erbb_mod)

# В данных наблюдался эффект полной коллинеарности. При этом функция vif не будет работать без дадания зополнительного параметра
# В этом случае можно посмотреть, какая переменная вносит этот эффект и удалить ее из модели. В этом случае это  ARC_N 
# Но даже так VIF большинства переменных очень высок.
# Можно сразу сделать вывод, что такая модель является плохим решением:
# Нарушаются многие условия применимости линейных моделей, в том числе присутствует мультиколлинеарность, от которой можно, конечно избавиться, убрав их
# модели предикторы с высоким vif, но придется убирать много и не факт, что модель будет хорошей при малом числе предикторов.
# В этом случае можно попробовать воспользоваться методами снижения размерности данных.


# 4. PCA
# Здесь я сделал датафрейм, в котором каждое наблюдение это среднее значения экспрессии белка для каждой мыши по повторностям 


mouse_wo_reps <- mouse_data_wo_na[, -c(1,3,4,5,6)] %>% group_by(id) %>% summarise_all('mean')
mouse_wo_reps <- arrange(mouse_wo_reps, id)
mouse_wo_reps
cl <- arrange(mouse_data_wo_na[!duplicated(mouse_data_wo_na$id), ][, c(2, 3)], id)$class
gn <- arrange(mouse_data_wo_na[!duplicated(mouse_data_wo_na$id), ], id)$Genotype
tr <- arrange(mouse_data_wo_na[!duplicated(mouse_data_wo_na$id), ], id)$Treatment
bh <- arrange(mouse_data_wo_na[!duplicated(mouse_data_wo_na$id), ], id)$Behavior

mouse_wo_reps$class <- cl
mouse_wo_reps$Genotype <- gn
mouse_wo_reps$Treatment <- tr
mouse_wo_reps$Behavior <- bh

# mouse_pca <- rda(exp_data, scale = T)

# head(summary(mouse_pca))

# biplot(mouse_pca)

mouse_wo_reps_pca <- rda(mouse_wo_reps[, -c(1, 79, 80, 81, 82)], scale = T)
head(summary(mouse_wo_reps_pca))


# Факторные нагрузки

biplot(mouse_wo_reps_pca)
biplot(mouse_wo_reps_pca, scaling = 'species', display = 'species')
biplot(mouse_wo_reps_pca, scaling = 'sites', display = 'sites')



mouse_pca_base<- prcomp(mouse_wo_reps[, -c(1, 79, 80, 81, 82)], scale = TRUE)
fviz_pca_ind(mouse_pca_base,
             geom.ind = "point", # show points only (nbut not "text")
             col.ind = mouse_wo_reps$Treatment, # color by groups
             palette = "Dark2",
            # addEllipses = TRUE, # Concentration ellipses
             legend.title = "factor"
)


# Интересно, что по генотипу мыши не разделяются в пространстве двух первых компонент
# а по переменной treatment да, мб препарат способен как-то компенсировать последсnвия синдрома дауна....

mouse_wo_reps

df_scores <- data.frame(mouse_wo_reps,
                        scores(mouse_wo_reps_pca, display = "sites", choices = c(1, 2, 3), scaling = "sites"))

df_scores

p_scores <- ggplot(df_scores[df_scores$Genotype == 'Ts65Dn', ], aes(x = PC1, y = PC2)) + 
  geom_point(aes(color = Treatment), alpha = 0.5) +
  coord_equal(xlim = c(-1.2, 1.2), ylim = c(-1.2, 1.2)) + ggtitle(label = "Ординация в осях главных компонент") + theme_bw()
p_scores







cols <- c("darkblue", "orange", "darkgreen", 'black', 'red',
          'yellow', 'blue', 'violet')


s3d <- scatterplot3d(df_scores$PC1,
              df_scores$PC2, 
              df_scores$PC3, 
              main="Ординация в осях главных компонент",
              xlab = "PC 1",
              ylab = "PC 2",
              zlab = "PC 3",
              pch = 16, color=cols[as.numeric(mouse_wo_reps$class)],
              box=F, angle = 25)

# source('addgrids3d.r')
# addgrids3d(df_scores$PC1,
#            df_scores$PC2, 
#            df_scores$PC3,
#            grid = c("xy", "xz", "yz"))













