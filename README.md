## Проекты по статистике в Институте биоинформатики 2020/21


### Содержание
1. [Проект № 1 &ndash; Первичный анализ данных и EDA](#eda)
2. [Проект № 2 &ndash; Линейные модели](#lm)
3. [Дополнительный проект &ndash; Дисперсионный анализ (ANOVA)](#anova)
3. [Проект № 3 &ndash; Анализ многомерных данных](#mouse)

### Первичный анализ данных и EDA <a name="eda"></a>

В ходе данного проекта предлагалось поработать с [данными](https://github.com/danon6868/BI_Stat_2020/tree/main/project_eda/Data) о моллюсках: их возраст, пол и различные размеры. Эти данные были собраны десятью людьми и находились в разных файлах.

Первое, что было необходимо сделать, это написать пользовательскую функцию для объединения этих файлов и привести данные в соответствие с конфепцией tidy data. Далее я провел краткий EDA, посчитал разные описательные статистики, сравнил некоторые группы мидий между собой и т.д. Более подробное описание заданий можно найти [здесь](https://github.com/danon6868/BI_Stat_2020/blob/main/project_eda/Project_1.pdf). 

В ходе дополнительной части я решил посмотреть, как влияет человек, собиравший данные на распределение различных переменных. В итоге выяснилось, что часто половой и возрастной состав моллюсков сильно отличается в данных разных людей. Это можно было бы связать с разными местами сбора материала, но дополнительной информацией я не располагал.

При желании Вы можете ознакомиться с отчетом по проделанной работе в формате [rdm](https://github.com/danon6868/BI_Stat_2020/blob/main/project_eda/project_eda.rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_eda). 

### Линейные модели <a name="lm"></a>
В рамках данной задачи я работал со встроенные в пакет MASS данными о стоимости жилья в Бостоне в 1070-80-х годах (датафрйм Boston). Нужно было посмотреть, как средняя стоимость домов, занимаемых взадельцами, зависит от различных факторов (близость к реке, количество учителей в школах и т.д.). Подробное описание задания можно найти [тут](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm.pdf) 

Основная часть работы состояла из следующих шагов:

1. Построение полной линейной модели со стандартизованными предикторами без их взаимодействия.
2. Диагностика полученной модели:
  1. Проверка линейности взаимосвязи
  2. Проверка на отсутствие влиятельных наблюдений
  3. Нормальность распределения остатков модели
  4. Постоянство дисперсии
3. Построение графика предсказаний стоимости от переменной, которая обладала нибольшим по модулю коэффициентом в модели

Полная модель оказалась довольно плохой, были нарушены практически все условия применимости линейных моделей.

В ходе дополнительной части нужно было постараться понять, на улучшениии каких аспектов стоит сосредоточиться, чтобы максимизировать цену за продаваемый дом и попытаться описать идеальный район для постройки дома.

В этой части я убрал некоторые предикторы, так как они вносили мультиколлинеарность в данные. Делал я это на основании расчета VIF (variance inflation factor), пороговое значение равнялось 2. После этого я оставил в модели только те предикторы, которые значимо влияют на зависимую переменную. В итоге модель получилась не идеальная, но сильно лучше, чем в первом шаге. В итоге мною был сформулирован ряд рекомендаций по выбору района для постройки домов. 

Подробный отчет в формате [rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_lm/project_lm_Rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_lm).

### Дисперсионный анализ (ANOVA) <a name="anova"></a>

В этой работе я анализировал [данные](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.pdf), которые были собраны двадцатью разными врачами. Я располагал информацией о двухста поциентах, для которых был известен пол, возраст, количество дней, поведенных в госпитале, наличие рецидива, а также тип лекарства, которым лечили данного пациента. 

Необоходимо было сделать следущее:

1. Написать пользовательскую функцию для объединения файлов одного расширения в общий датафрейм. Эта функция принимает путь до папки с данными, а также тип файлов, которые она будет анализировать.
2. Проверить корректность данных и привести их в соответствие с концепцией tidy data. Провести EDA.
3. Провести двухфакторный дисперсионный анализ (по факторам тип лекарства и пол) числа дней в госпитале.
4. Проверить условия применимости дисперсионного анализа.
5. Провести трактовку результатов модели.
6. Выполнить пост-хок тесты и описать полученные результаты.

Основной результат работы состоит в том, что людям разного пола необходимо выписывать разные типы лекарств. Неверно подобранный препарат может даже увеличить время восстановления по сравнению с плацебо.

Вы можете посмотреть подробный отчет с формате [rmd](https://github.com/danon6868/BI_Stat_2020/blob/main/project_anova/project_anova.Rmd) и [html](https://danon6868.github.io/BI_Stat_2020/project_anova).

### Анализ многомерных данный <a name="mouse"></a>

Данный проект находится в работе...

[https://danon6868.github.io/BI_Stat_2020/project_mouse]
