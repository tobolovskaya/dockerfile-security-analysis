# Інструкція для роботи з GitLab

## 📋 Покрокова інструкція

### Крок 1: Вхід у GitLab

1. Відкрийте браузер
2. Перейдіть на https://gitlab.com (або ваш GitLab інстанс)
3. Увійдіть з вашим обліковим записом

### Крок 2: Створення нового проєкту

1. Натисніть кнопку **"New project"** або **"Новий проєкт / репозиторій"**
2. Виберіть **"Create blank project"** або **"Створити пустий проєкт"**
3. Заповніть форму:
   - **Project name**: `docker-security`
   - **Project URL**: виберіть свого користувача
   - **Visibility Level**: Private або Public (на ваш розсуд)
   - **Initialize repository with a README**: знімаємо галочку
4. Натисніть **"Create project"**

### Крок 3: Налаштування Git локально

```powershell
# Перейдіть у папку проєкту
cd c:\Users\yevheniiat\GitHub\Dockerfile-GitLab-CI-CD

# Ініціалізуйте git (якщо ще не ініційовано)
git init

# Додайте remote (замініть YOUR_USERNAME на ваш логін)
git remote add origin https://gitlab.com/YOUR_USERNAME/docker-security.git

# Або через SSH
git remote add origin git@gitlab.com:YOUR_USERNAME/docker-security.git
```

### Крок 4: Додавання файлів до репозиторію

```powershell
# Додайте всі файли
git add .

# Створіть коміт
git commit -m "Initial commit: Add Docker security lab files"

# Відправте на GitLab
git push -u origin main
```

**Альтернатива - якщо у вас гілка master:**
```powershell
git push -u origin master
```

---

## 🧪 Тестування Docker-bad

### Крок 5: Перейменування Docker-bad на Dockerfile

```powershell
# Видаліть існуючий Dockerfile (якщо є)
git rm Dockerfile

# Перейменуйте Docker-bad на Dockerfile
git mv Docker-bad Dockerfile

# Або просто скопіюйте
copy Docker-bad Dockerfile
git add Dockerfile

# Створіть коміт
git commit -m "Test: Use Docker-bad as Dockerfile"

# Відправте зміни
git push
```

### Крок 6: Перегляд результатів Pipeline

1. Перейдіть у GitLab до вашого проєкту
2. У лівому меню виберіть **"CI/CD" → "Pipelines"**
3. Знайдіть свій pipeline (він буде з статусом "running" або "failed")
4. Натисніть на номер pipeline, щоб побачити деталі
5. Перегляньте результати кожного job:
   - **hadolint** - перевірка синтаксису
   - **trivy** - сканування безпеки
   - **dockle** - аудит best practices

### Крок 7: Аналіз помилок

#### Hadolint (⚠️ Warning, allow_failure: true)
Натисніть на job "hadolint" та подивіться на вивід:
- `DL3008`: Не зафіксовано версії пакетів
- `DL3009`: Не видалено apt кеш
- `DL3020`: Використано ADD замість COPY

#### Trivy (❌ Failed, allow_failure: false)
Натисніть на job "trivy" та подивіться на вивід:
- `HIGH`: Running as root user
- `MEDIUM`: Missing HEALTHCHECK
- `LOW`: Unsafe apt-get usage

#### Dockle (❌ Failed, allow_failure: false)
Натисніть на job "dockle" та подивіться на вивід:
- `CIS-DI-0001`: Create a user for the container
- `CIS-DI-0006`: Add HEALTHCHECK instruction
- `DKL-DI-0005`: Clear apt cache

**Очікуваний результат:** Pipeline має статус **Failed** через trivy або dockle.

---

## ✅ Тестування Docker-good

### Крок 8: Заміна на Docker-good

```powershell
# Видаліть поточний Dockerfile
Remove-Item Dockerfile

# Скопіюйте Docker-good як Dockerfile
copy Docker-good Dockerfile
git add Dockerfile

# Створіть коміт
git commit -m "Fix: Use Docker-good as Dockerfile"

# Відправте зміни
git push
```

### Крок 9: Перегляд успішного Pipeline

1. Перейдіть знову до **"CI/CD" → "Pipelines"**
2. Дочекайтесь завершення нового pipeline
3. Перегляньте результати:
   - **hadolint** ✅ - Немає помилок
   - **trivy** ✅ - Немає вразливостей
   - **dockle** ✅ - Всі перевірки пройдено

**Очікуваний результат:** Pipeline має статус **Passed** (зелений).

### Крок 10: Завантаження артефактів

1. У job "dockle" знайдіть розділ **"Job artifacts"**
2. Завантажте файл `dockle-report.json`
3. Відкрийте його у текстовому редакторі
4. Порівняйте звіти для Docker-bad і Docker-good

---

## 📊 Що повинно бути у звітах

### Docker-bad результати:

**Hadolint:**
```
DL3008 warning: Pin versions in apt get install
DL3009 info: Delete the apt-get lists after installing
DL3020 error: Use COPY instead of ADD
```

**Trivy:**
```
HIGH: Container is running as root
MEDIUM: Missing HEALTHCHECK instruction
LOW: apt-get install without --no-install-recommends
```

**Dockle:**
```
FATAL   - CIS-DI-0001: Create a user for the container
WARN    - CIS-DI-0006: Add HEALTHCHECK instruction
INFO    - DKL-DI-0005: Clear apt-get lists
```

### Docker-good результати:

**Hadolint:**
```
No issues found ✅
```

**Trivy:**
```
No misconfigurations found ✅
```

**Dockle:**
```
All checks passed ✅
```

---

## 🔍 Додаткові завдання (опціонально)

### 1. Експеримент з allow_failure

Спробуйте змінити конфігурацію `.gitlab-ci.yml`:

```yaml
hadolint:
  allow_failure: false  # Змінити на false

trivy:
  allow_failure: true   # Змінити на true
```

**Питання:** Як це вплине на поведінку pipeline?

### 2. Додавання власних правил

Додайте у `.gitlab-ci.yml` більш строгі перевірки:

```yaml
trivy:
  script:
    - docker run --rm -v $PWD:/mnt aquasec/trivy config --severity HIGH,CRITICAL --exit-code 1 /mnt/$DOCKERFILE_PATH
```

### 3. Створення merge request

1. Створіть нову гілку: `git checkout -b feature/improve-security`
2. Внесіть зміни у Dockerfile
3. Відправте гілку: `git push origin feature/improve-security`
4. У GitLab створіть Merge Request
5. Подивіться, як pipeline працює для MR

---

## 🐛 Troubleshooting

### Проблема: Pipeline не запускається

**Рішення:**
1. Перевірте, що файл називається `.gitlab-ci.yml` (з крапкою!)
2. Перевірте YAML синтаксис: https://www.yamllint.com/
3. Переконайтесь, що у проєкті увімкнено CI/CD:
   - Settings → CI/CD → Auto DevOps (має бути вимкнено)
   - Settings → CI/CD → Runners (має бути хоча б один runner)

### Проблема: Job "dockle" падає з timeout

**Рішення:**
```yaml
dockle:
  timeout: 30 minutes  # Збільшіть час
```

### Проблема: Docker daemon not available

**Рішення:**
- Переконайтесь, що використовується `docker:dind` сервіс
- Перевірте, що у GitLab є доступні Docker runners

### Проблема: Permission denied

**Рішення:**
```powershell
# Налаштуйте SSH ключі для GitLab
ssh-keygen -t ed25519 -C "your_email@example.com"

# Скопіюйте публічний ключ
Get-Content ~/.ssh/id_ed25519.pub | clip

# Додайте у GitLab: Settings → SSH Keys
```

---

## 📝 Контрольний список

- [ ] Створено проєкт у GitLab
- [ ] Додано всі файли до репозиторію
- [ ] Протестовано Docker-bad
- [ ] Проаналізовано помилки від усіх трьох інструментів
- [ ] Протестовано Docker-good
- [ ] Порівняно результати
- [ ] Завантажено артефакти (dockle-report.json)
- [ ] Сформульовано висновки
- [ ] Заповнено звіт (ANALYSIS.md)

---

## 🎯 Критерії оцінювання

1. **Pipeline налаштовано** - 20%
2. **Виявлено проблеми у Docker-bad** - 20%
3. **Docker-good проходить всі перевірки** - 20%
4. **Зроблено порівняльний аналіз** - 20%
5. **Сформульовано висновки** - 20%

**Максимальний бал:** 100%

---

## 📞 Підтримка

Якщо виникли проблеми:
1. Перевірте файл [README.md](README.md)
2. Перегляньте [COMPARISON.md](COMPARISON.md)
3. Вивчіть детальний [ANALYSIS.md](ANALYSIS.md)
4. Зверніться до викладача

---

**Успіхів у виконанні лабораторної роботи! 🚀**
