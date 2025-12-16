# ⚡ Швидкий старт (5 хвилин)

Якщо у вас обмаль часу, ось мінімальний набір дій для початку роботи.

---

## 🎯 Для студентів (лабораторна робота)

### Крок 1: Прочитайте це (2 хв)
- [INDEX.md](INDEX.md) - навігація по документах
- [README.md](README.md) - загальний огляд

### Крок 2: Створіть проєкт у GitLab (10 хв)
1. Увійдіть на https://gitlab.com
2. Створіть проєкт "docker-security"
3. Налаштуйте Git:
   ```powershell
   git clone https://gitlab.com/YOUR_USERNAME/docker-security.git
   cd docker-security
   ```

### Крок 3: Додайте файли (5 хв)
```powershell
# Скопіюйте всі файли з поточної папки
copy c:\Users\yevheniiat\GitHub\Dockerfile-GitLab-CI-CD\* .

# Перейменуйте Docker-bad на Dockerfile
copy Docker-bad Dockerfile

# Додайте до git
git add .
git commit -m "Add Docker security lab files"
git push
```

### Крок 4: Дочекайтесь результатів (5-10 хв)
1. Перейдіть у GitLab → CI/CD → Pipelines
2. Подивіться на результати (має бути failed)
3. Перегляньте помилки у hadolint, trivy, dockle

### Крок 5: Тестуйте Docker-good (5 хв)
```powershell
# Замініть Dockerfile на Docker-good
copy Docker-good Dockerfile
git add Dockerfile
git commit -m "Fix: Use Docker-good"
git push
```

### Крок 6: Підготуйте відповіді (30 хв)
Прочитайте і використовуйте для звіту:
- [COMPARISON.md](COMPARISON.md) - що змінилося
- [CONCLUSIONS.md](CONCLUSIONS.md) - відповіді на питання
- [ANALYSIS.md](ANALYSIS.md) - шаблон звіту

**Загальний час: ~1 година**

---

## 💻 Для розробників (практика)

### Якщо хочете швидко навчитися безпеці Docker:

1. **Прочитайте (15 хв):**
   - [SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md)
   - [COMPARISON.md](COMPARISON.md)

2. **Використовуйте як шаблон:**
   - [Docker-good](Docker-good) - безпечний Dockerfile
   - [.gitlab-ci.yml](.gitlab-ci.yml) - CI/CD конфігурація
   - [.dockerignore](.dockerignore) - виключення файлів

3. **Локально тестуйте:**
   ```bash
   # Hadolint
   docker run --rm -i hadolint/hadolint < Dockerfile
   
   # Trivy
   docker run --rm -v $PWD:/mnt aquasec/trivy config /mnt/Dockerfile
   
   # Dockle
   docker build -t test .
   docker run --rm goodwithtech/dockle test
   ```

**Загальний час: 30 хвилин**

---

## 📚 Повна документація

Якщо хочете глибоке розуміння:
- [INDEX.md](INDEX.md) - навігація
- [GITLAB_INSTRUCTIONS.md](GITLAB_INSTRUCTIONS.md) - детальна інструкція
- [ANALYSIS.md](ANALYSIS.md) - повний аналіз
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - опис проєкту

---

## 🆘 Допомога

**Проблеми з GitLab?**  
→ [GITLAB_INSTRUCTIONS.md - Troubleshooting](GITLAB_INSTRUCTIONS.md#-troubleshooting)

**Не розумію помилки?**  
→ [COMPARISON.md - Виявлені проблеми](COMPARISON.md#-виявлені-проблеми-по-інструментам)

**Потрібні відповіді?**  
→ [CONCLUSIONS.md](CONCLUSIONS.md)

---

**Успіхів! 🚀**
