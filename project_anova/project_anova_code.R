library(dplyr)
library(readxl)
library(ggplot2)
library(car)
library(multcomp)

# 1))))
# Пользовательская функция для объединения в таблицу файлов указанного расширения
data_join <- function(directory, extension = 'csv'){
  
  # Именованный вектор с функциями для чтения файлов с различными расширениями
  functions <- c(csv = read.csv, 
                 tsv = read.delim, 
                 csv2 = read.csv2, 
                 xls = read_excel,
                 xlsx = read_excel,
                 .csv = read.csv, 
                 .tsv = read.delim, 
                 .csv2 = read.csv2, 
                 .xls = read_excel,
                 .xlsx = read_excel)
  
  df <- data.frame()
  for (file in list.files(directory)){
    if (endsWith(file, suffix = extension)){
      data <- functions[extension][[1]](paste0(directory, file))
      df <- rbind(df, data)
    }
  }
  
  # Сортируем по порядку названий файлов (переменная X)
  # Удаляем ее из итоговой таблицы
  df <- arrange(df, colnames(df)[1])[, -1]
  
  # В задании написано также объединить файлы в один файл, пусть будет так)
  if (!dir.exists(paste0(directory, 'full_out/'))){
    dir.create(paste0(directory, 'full_out/'))
  }
  if (startsWith(extension, prefix = '.')){
    write.csv(df, paste0(directory, 'full_out/whole_data', extension))
  }
  else {
    write.csv(df, paste0(directory, 'full_out/whole_data.', extension))
  }

  return(df)
}

# Объединенные данные


# 2)))
# Проверим, правильно ли все открылось
drug_data <- data_join('Homework/Project_ad_ANOVA/Data/')
str(drug_data)
dim(drug_data)
apply(apply(drug_data, 2, is.na), 2, sum)

# Видим, что есть 10 отсутствующих значений в одной переменной, которая отражает наличие рецидива. 
# Я заменю все NA на нули, обосновывая это тем, что, скорее всего, если рецидива и правда не было, врач мог просто забыть
# написать о его отсутствии. А выкидывать 5 % данных при таком небольшом числе наблюдений не хочется.
drug_data$is_relapse[is.na(drug_data$is_relapse)] <-  0

# Сразу видим, что возраст имеет строковый тип, это надо будет исправить
# Также можно привести тип переменной is_relapse в фактор
# Посмотрим, какие вообще типы значений мы имеем по разным переменным:
unique(drug_data$gender)

# Сразу видно, что есть ошибки при сборе данных. Исправляем:
drug_data$gender[drug_data$gender == 'malle'] <- 'male'
unique(drug_data$gender)
drug_data$gender <- as.factor(drug_data$gender)

# Здесь вообще интересно, но что поделать
unique(drug_data$age)
drug_data$age[drug_data$age == 'thirty-one'] <- 31
drug_data$age[drug_data$age == '350'] <- 35
drug_data$age[drug_data$age == '220'] <- 22
drug_data$age <- as.integer(drug_data$age)
unique(drug_data$age)

unique(drug_data$drug_type)
drug_data$drug_type <- as.factor(drug_data$drug_type)
unique(drug_data$is_relapse)
drug_data$is_relapse <- as.factor(drug_data$is_relapse)

dim(drug_data)
str(drug_data)
head(drug_data)

# Теперь данные выглядят хорошо, и их можно использовать для дальнейшего анализа


# EDA

dim(drug_data)

# Всего в данных 200 наблюдений и 6 переменных.

theme_set(theme_bw())


ggplot(drug_data, aes(drug_type, fill = is_relapse)) +
  geom_bar() +
  ggtitle('Распределение числа пациентов\nпо наличию рецидива и типу лекарства') +
  scale_fill_manual(values = c('0' = '#EBECB3',
                               '1' = '#B3ECDD'),
                    name = "Рецидив", labels = c('Нет', 'Да')) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Тип лекарства') + 
  ylab('Количество пациентов') 


ggplot(drug_data, aes(drug_type, fill = gender)) +
  geom_bar() +
  ggtitle('Распределение числа пациентов\nпо полу и типу лекарства') +
  scale_fill_manual(values = c('female' = '#EBECB3',
                               'male' = '#B3ECDD'),
                    name = "Пол", labels = c('Женский', 'Мужской')) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Тип лекарства') + 
  ylab('Количество пациентов') 


ggplot(drug_data, aes(x = drug_type, y = days_in_hospital)) +
  geom_boxplot(aes(fill = gender)) + 
  scale_fill_manual(values = c('female' = '#EBECB3',
                               'male' = '#B3ECDD'),
                    name = "Пол", labels = c('Женский', 'Мужской')) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Тип лекарства') + 
  ylab('Количество дней в госпитале') +
  ggtitle('Распределение числа дней в госпитале\nпо полу и типу лекарства')


# 3)))

hosp_duration_mod <- lm(days_in_hospital ~ gender + drug_type, data = drug_data)
av_hosp_duration_mod <- Anova(mod = hosp_duration_mod)

# Проверим условия применимости

mod_diag <- fortify(hosp_duration_mod)

# График расстояний Кука выглядит хорошо, нет влиятельных наблюдений
ggplot(mod_diag, aes(x = 1:nrow(mod_diag), y = .cooksd)) +
  geom_bar(stat = 'identity') 


# Графики остатков выглядят не очань хорошо, много наблюдений за пределами двух стандартных отклонений
ggplot(mod_diag, aes(x = drug_type, y = .stdresid)) +
  geom_boxplot(aes(fill = gender)) + 
  scale_fill_manual(values = c('female' = '#EBECB3',
                               'male' = '#B3ECDD'),
                    name = "Пол", labels = c('Женский', 'Мужской')) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Тип лекарства') + 
  ylab('Стандартизованные остатки') +
  ggtitle('Распределение стандартизованных остатков модели\nпо полу и типу лекарства')


ggplot(data = mod_diag, aes(x = .fitted, y = .stdresid)) + 
  geom_point() + 
  geom_hline(yintercept = 0) +
  geom_smooth(method = "lm") +
  geom_hline(yintercept = 2, color = "red") +
  geom_hline(yintercept = -2, color = "red") +
  xlab('Предсказанное значение') + 
  ylab('Стандартизованные остатки')


# В целом распределение остатков значимо не отличается от нормального
qqPlot(hosp_duration_mod)
shapiro.test(mod_diag$.resid)


# Графики остатков выглядели плохо. 
# Исходя из (ссылка на первый боксплот) можно заподозрить наличие взаимодействия между предикторами

inter_model <- lm(days_in_hospital ~ gender * drug_type, data = drug_data)
av_inter_model <- Anova(mod = inter_model)


inter_mod_diag <- fortify(inter_model)


ggplot(inter_mod_diag, aes(x = 1:nrow(mod_diag), y = .cooksd)) +
  geom_bar(stat = 'identity') 


ggplot(inter_mod_diag, aes(x = drug_type, y = .stdresid)) +
  geom_boxplot(aes(fill = gender)) + 
  scale_fill_manual(values = c('female' = '#EBECB3',
                               'male' = '#B3ECDD'),
                    name = "Пол", labels = c('Женский', 'Мужской')) +
  theme(plot.title = element_text(hjust = 0.5)) + 
  xlab('Тип лекарства') + 
  ylab('Стандартизованные остатки') +
  ggtitle('Распределение стандартизованных остатков модели\nпо полу и типу лекарства\n(модель со взаимодействием предикторов)')


ggplot(data = inter_mod_diag, aes(x = .fitted, y = .stdresid)) + 
  geom_point() + 
  geom_hline(yintercept = 0) +
  geom_smooth(method = "lm") +
  geom_hline(yintercept = 2, color = "red") +
  geom_hline(yintercept = -2, color = "red") +
  xlab('Предсказанное значение') + 
  ylab('Стандартизованные остатки')


qqPlot(inter_model)
shapiro.test(inter_mod_diag$.resid)


# Интерпретация результатов

av_inter_model


# Пост-хок тесты

drug_data$Condition <- as.factor(paste(drug_data$gender, drug_data$drug_type, sep = '_'))
inter_fit <- lm(days_in_hospital ~ Condition - 1, data = drug_data)


res_tukey <- glht(inter_fit, linfct = mcp(Condition = 'Tukey'))
summary(res_tukey)
