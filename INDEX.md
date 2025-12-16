# 📚 Навігація по проєкту

Ласкаво просимо до проєкту "Аналіз безпеки Dockerfile у GitLab CI/CD"!

---

## 🚀 Швидкий старт

### Якщо ви вперше тут:
1. Прочитайте [README.md](README.md) - загальний огляд проєкту
2. Ознайомтесь з [GITLAB_INSTRUCTIONS.md](GITLAB_INSTRUCTIONS.md) - покрокова інструкція
3. Перегляньте [COMPARISON.md](COMPARISON.md) - наочне порівняння Docker-bad vs Docker-good

### Якщо ви виконуєте лабораторну роботу:
1. 📖 [GITLAB_INSTRUCTIONS.md](GITLAB_INSTRUCTIONS.md) - детальна інструкція з виконання
2. 📊 [CONCLUSIONS.md](CONCLUSIONS.md) - відповіді на всі питання лабораторної
3. 📝 [ANALYSIS.md](ANALYSIS.md) - повний звіт про аналіз безпеки

---

## 📂 Структура документації

### 🎯 Основні документи

#### [README.md](README.md)
**Призначення:** Загальний огляд проєкту  
**Містить:**
- Опис структури проєкту
- Швидкий старт
- Очікувані результати
- Основні проблеми безпеки

**Читати:** Всім на початку роботи ⭐

---

#### [GITLAB_INSTRUCTIONS.md](GITLAB_INSTRUCTIONS.md)
**Призначення:** Покрокова інструкція для GitLab  
**Містить:**
- Створення проєкту у GitLab
- Git команди
- Тестування Docker-bad і Docker-good
- Troubleshooting
- Контрольний список

**Читати:** Під час виконання лабораторної роботи ⭐⭐⭐

---

#### [COMPARISON.md](COMPARISON.md)
**Призначення:** Візуальне порівняння Docker-bad vs Docker-good  
**Містить:**
- Код обох Dockerfile
- Детальну таблицю порівняння
- Результати від кожного інструменту
- Метрики (розмір, вразливості)
- Критичні відмінності

**Читати:** Для розуміння різниці між безпечним і небезпечним Dockerfile ⭐⭐⭐

---

#### [CONCLUSIONS.md](CONCLUSIONS.md)
**Призначення:** Відповіді на питання лабораторної роботи  
**Містить:**
- Які типи перевірок виконує кожен інструмент?
- Як GitLab реагує на порушення?
- Які практики вважаються безпечними?
- Які порушення є критичними?
- Чому важливо запускати всі три інструменти?
- Як створити безпечний Dockerfile?

**Читати:** Для підготовки відповідей та висновків ⭐⭐⭐

---

#### [ANALYSIS.md](ANALYSIS.md)
**Призначення:** Повний академічний звіт  
**Містить:**
- Мета роботи
- Детальний аналіз інструментів
- Порівняльний аналіз Docker-bad vs Docker-good
- Поведінка GitLab CI/CD Pipeline
- Практичні рекомендації
- Висновки

**Читати:** Для здачі лабораторної роботи ⭐⭐⭐

---

### 🛠️ Довідкові документи

#### [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)
**Призначення:** Чеклист безпеки Dockerfile  
**Містить:**
- 10 обов'язкових практик безпеки
- Приклади правильного і неправильного коду
- Критичні помилки (НІКОЛИ не робіть це!)
- Рівні пріоритету
- Приклад ідеального Dockerfile

**Читати:** При написанні власних Dockerfile ⭐⭐

---

### 📄 Файли конфігурації

#### [.gitlab-ci.yml](.gitlab-ci.yml)
**Призначення:** Конфігурація CI/CD pipeline  
**Містить:**
- 3 етапи (lint, scan, audit)
- Налаштування hadolint, trivy, dockle
- allow_failure правила

**Використовувати:** Завантажити у GitLab проєкт

---

#### [.dockerignore](.dockerignore)
**Призначення:** Виключення файлів з Docker образу  
**Містить:**
- Git файли
- Документація
- Логи і звіти
- IDE файли
- Секрети

**Використовувати:** У всіх Docker проєктах

---

### 🔍 Приклади Dockerfile

#### [Docker-bad](Docker-bad)
**Призначення:** Приклад небезпечного Dockerfile  
**Містить:**
- Запуск від root
- ADD замість COPY
- Відсутність --no-install-recommends
- Відсутність HEALTHCHECK
- Великий базовий образ

**Використовувати:** Для порівняння та навчання

---

#### [Docker-good](Docker-good)
**Призначення:** Приклад безпечного Dockerfile  
**Містить:**
- Slim образ
- Непривілейований користувач
- HEALTHCHECK
- Правильне встановлення пакетів
- Оптимізація розміру

**Використовувати:** Як шаблон для власних проєктів ⭐

---

## 🎓 Рекомендований порядок вивчення

### Для студентів (лабораторна робота):

```
1. README.md                    (5 хв)   - Загальне розуміння
2. GITLAB_INSTRUCTIONS.md       (10 хв)  - Покрокова інструкція
3. [Виконання у GitLab]         (30 хв)  - Практична робота
4. COMPARISON.md                (15 хв)  - Аналіз результатів
5. CONCLUSIONS.md               (20 хв)  - Підготовка відповідей
6. ANALYSIS.md                  (30 хв)  - Фінальний звіт
```

**Загальний час:** ~2 години

---

### Для розробників (практичне застосування):

```
1. SECURITY_CHECKLIST.md        (20 хв)  - Вивчення best practices
2. COMPARISON.md                (10 хв)  - Розуміння проблем
3. Docker-good                  (5 хв)   - Використання як шаблон
4. .gitlab-ci.yml               (10 хв)  - Налаштування CI/CD
```

**Загальний час:** ~45 хвилин

---

### Для викладачів (перевірка робіт):

```
1. ANALYSIS.md                  - Основний звіт студента
2. CONCLUSIONS.md               - Відповіді на питання
3. [GitLab Pipeline результати] - Практичне виконання
```

---

## 🔗 Корисні посилання

### Документація інструментів:
- [Hadolint GitHub](https://github.com/hadolint/hadolint)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Dockle GitHub](https://github.com/goodwithtech/dockle)

### Стандарти безпеки:
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Docker Security](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

### GitLab:
- [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
- [GitLab Runner](https://docs.gitlab.com/runner/)

---

## 📊 Швидка довідка

### Локальне тестування:

```bash
# Hadolint
docker run --rm -i hadolint/hadolint < Dockerfile

# Trivy
docker run --rm -v $PWD:/mnt aquasec/trivy config /mnt/Dockerfile

# Dockle
docker build -t test-image .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle test-image
```

### Git команди:

```bash
# Клонування проєкту
git clone https://gitlab.com/YOUR_USERNAME/docker-security.git

# Тестування Docker-bad
git mv Docker-bad Dockerfile
git commit -m "Test Docker-bad"
git push

# Тестування Docker-good
git mv Docker-good Dockerfile
git commit -m "Test Docker-good"
git push
```

---

## 🎯 Критерії оцінювання

| Критерій | Вага | Де знайти |
|----------|------|-----------|
| Pipeline налаштовано | 20% | [GITLAB_INSTRUCTIONS.md](GITLAB_INSTRUCTIONS.md) |
| Виявлено проблеми у Docker-bad | 20% | [COMPARISON.md](COMPARISON.md) |
| Docker-good проходить перевірки | 20% | [COMPARISON.md](COMPARISON.md) |
| Порівняльний аналіз | 20% | [ANALYSIS.md](ANALYSIS.md) |
| Висновки | 20% | [CONCLUSIONS.md](CONCLUSIONS.md) |

---

## 💡 Поради

### При виникненні проблем:

1. **Pipeline не запускається**  
   → [GITLAB_INSTRUCTIONS.md - Troubleshooting](GITLAB_INSTRUCTIONS.md#-troubleshooting)

2. **Не розумію помилки**  
   → [COMPARISON.md - Виявлені проблеми](COMPARISON.md#-виявлені-проблеми-по-інструментам)

3. **Не знаю, як виправити**  
   → [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)

4. **Потрібні відповіді на питання**  
   → [CONCLUSIONS.md](CONCLUSIONS.md)

---

## 📧 Контакти та підтримка

**Студент:** Yevheniia Tobolovska  
**Проєкт:** Dockerfile Security Analysis Lab  
**Дата:** Грудень 2025

---

## ✅ Контрольний список готовності

Перед здачею лабораторної переконайтесь:

- [ ] Прочитано [README.md](README.md)
- [ ] Створено проєкт у GitLab
- [ ] Протестовано Docker-bad (pipeline failed)
- [ ] Протестовано Docker-good (pipeline success)
- [ ] Проаналізовано помилки від усіх трьох інструментів
- [ ] Заповнено висновки в [CONCLUSIONS.md](CONCLUSIONS.md)
- [ ] Підготовлено фінальний звіт [ANALYSIS.md](ANALYSIS.md)
- [ ] Завантажено скріншоти з GitLab
- [ ] Перевірено всі відповіді на питання

---

**Успіхів у виконанні лабораторної роботи! 🚀**


