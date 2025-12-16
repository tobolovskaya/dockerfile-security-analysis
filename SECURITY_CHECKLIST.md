# 🔒 Dockerfile Security Checklist

## ✅ Обов'язкові практики безпеки

### 1. Базовий образ
- [ ] Використовується slim/alpine версія образу
- [ ] Зафіксована конкретна версія образу (не `latest`)
- [ ] Використовується офіційний образ з Docker Hub
- [ ] Перевірено дату оновлення базового образу (< 6 місяців)

**Приклад:**
```dockerfile
✅ FROM debian:12.5-slim
❌ FROM debian:latest
❌ FROM debian
```

---

### 2. Користувач (КРИТИЧНО!)
- [ ] Створено непривілейованого користувача
- [ ] Встановлено `USER` перед CMD/ENTRYPOINT
- [ ] Користувач має мінімальні необхідні права
- [ ] UID/GID користувача чітко визначені

**Приклад:**
```dockerfile
✅ RUN useradd -m -u 1000 -s /bin/bash appuser
✅ USER appuser

❌ # Немає USER - контейнер працює як root
```

**Чому це критично:**
- Якщо додаток скомпрометовано, зловмисник НЕ матиме root-права
- Обмежується доступ до файлової системи хоста
- Зменшується ризик ескалації привілеїв

---

### 3. Встановлення пакетів
- [ ] Використовується `--no-install-recommends`
- [ ] Видаляється кеш пакетного менеджера
- [ ] Всі команди в одному `RUN` (для зменшення шарів)
- [ ] Зафіксовані версії критичних пакетів

**Приклад:**
```dockerfile
✅ RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl=7.88.1-* \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

❌ RUN apt-get update
❌ RUN apt-get install -y curl
```

---

### 4. Копіювання файлів
- [ ] Використовується `COPY` замість `ADD`
- [ ] Копіюються лише необхідні файли
- [ ] Використовується `.dockerignore`
- [ ] Змінюється власник файлів (якщо потрібно)

**Приклад:**
```dockerfile
✅ COPY --chown=appuser:appuser app/ /app/
✅ COPY requirements.txt .

❌ ADD . /app/  # ADD має додаткову функціональність
❌ COPY . .     # Копіює все, включно з .git
```

---

### 5. HEALTHCHECK
- [ ] Додано `HEALTHCHECK` інструкцію
- [ ] Налаштовано розумні інтервали перевірки
- [ ] Команда перевірки не перевантажує додаток
- [ ] Визначено кількість retries

**Приклад:**
```dockerfile
✅ HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
     CMD curl --fail http://localhost:8080/health || exit 1

❌ # Немає HEALTHCHECK
```

---

### 6. Мінімізація розміру
- [ ] Видалено тимчасові файли
- [ ] Об'єднано команди в multi-line RUN
- [ ] Використано multi-stage build (якщо потрібно)
- [ ] Видалено непотрібні файли з фінального образу

**Приклад:**
```dockerfile
✅ RUN apt-get update && apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

❌ RUN apt-get update
❌ RUN apt-get install -y curl
❌ RUN rm -rf /var/lib/apt/lists/*  # Окремі шари
```

---

### 7. Секрети та конфіденційні дані
- [ ] Секрети НЕ включені в образ
- [ ] Використовуються Docker secrets або BuildKit secrets
- [ ] .env файли в .dockerignore
- [ ] Немає hardcoded паролів/ключів

**Приклад:**
```dockerfile
✅ RUN --mount=type=secret,id=api_key \
     API_KEY=$(cat /run/secrets/api_key) && \
     do_something_with_key

❌ ENV API_KEY=super_secret_key  # НІКОЛИ так не робіть!
❌ COPY .env /app/.env           # НІКОЛИ так не робіть!
```

---

### 8. Порти та мережа
- [ ] Документовані всі відкриті порти (`EXPOSE`)
- [ ] Відкриті лише необхідні порти
- [ ] Використовуються непривілейовані порти (> 1024)

**Приклад:**
```dockerfile
✅ EXPOSE 8080
✅ EXPOSE 3000

❌ EXPOSE 80    # Потребує root для прив'язки
❌ EXPOSE 443   # Потребує root для прив'язки
```

---

### 9. CMD/ENTRYPOINT
- [ ] Використовується exec форма (JSON array)
- [ ] Команда запуску документована
- [ ] Не використовується shell form (якщо не потрібно)

**Приклад:**
```dockerfile
✅ CMD ["node", "app.js"]
✅ ENTRYPOINT ["python3", "-u", "main.py"]

❌ CMD node app.js              # Shell form - не рекомендується
❌ CMD ["sh", "-c", "node app"] # Зайвий shell wrapper
```

---

### 10. Метадані
- [ ] Додані `LABEL` з інформацією про образ
- [ ] Вказано maintainer
- [ ] Додано опис призначення
- [ ] Вказано версію (якщо застосовно)

**Приклад:**
```dockerfile
✅ LABEL maintainer="team@example.com"
✅ LABEL description="Production-ready Node.js application"
✅ LABEL version="1.0.0"
```

---

## 🔍 Перевірка перед деплоєм

### Локальне тестування

```bash
# 1. Hadolint
docker run --rm -i hadolint/hadolint < Dockerfile

# 2. Trivy
docker run --rm -v $PWD:/mnt aquasec/trivy config /mnt/Dockerfile

# 3. Build образу
docker build -t myapp:test .

# 4. Dockle
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  goodwithtech/dockle myapp:test

# 5. Перевірка розміру
docker images myapp:test

# 6. Перевірка користувача
docker run --rm myapp:test whoami  # Не повинно бути root
```

---

## 🚨 Критичні помилки (НІКОЛИ не робіть це!)

### ❌ 1. Запуск від root
```dockerfile
# Немає USER - контейнер працює як root
CMD ["node", "app.js"]
```

### ❌ 2. Збереження секретів в образі
```dockerfile
ENV DATABASE_PASSWORD=secret123
COPY .env /app/.env
```

### ❌ 3. Використання latest тегів
```dockerfile
FROM node:latest
FROM ubuntu
```

### ❌ 4. Копіювання всього проєкту
```dockerfile
COPY . .  # Включає .git, node_modules, тощо
```

### ❌ 5. Встановлення непотрібних пакетів
```dockerfile
RUN apt-get install -y \
  build-essential \
  git \
  vim \
  # ... багато іншого
```

---

## 📊 Рівні пріоритету

### 🔴 КРИТИЧНО (Блокує деплой)
- [ ] Не використовується root
- [ ] Немає секретів в образі
- [ ] Зафіксовані версії базових образів

### 🟡 ВАЖЛИВО (Має бути виправлено)
- [ ] Додано HEALTHCHECK
- [ ] Використано slim образи
- [ ] Очищено кеш пакетів

### 🟢 РЕКОМЕНДОВАНО (Покращує якість)
- [ ] Додано LABEL
- [ ] Використано .dockerignore
- [ ] Оптимізовано кількість шарів

---

## 📚 Додаткові ресурси

### Документація
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Docker Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html)

### Інструменти
- [Hadolint](https://github.com/hadolint/hadolint) - Dockerfile linter
- [Trivy](https://aquasecurity.github.io/trivy/) - Security scanner
- [Dockle](https://github.com/goodwithtech/dockle) - Container image linter
- [Grype](https://github.com/anchore/grype) - Vulnerability scanner
- [Snyk](https://snyk.io/) - Security platform

---

## 🎯 Приклад ідеального Dockerfile

```dockerfile
# Використання slim образу зі зафіксованою версією
FROM python:3.11.7-slim

# Метадані
LABEL maintainer="devteam@example.com"
LABEL description="Production Python application"
LABEL version="1.0.0"

# Змінні середовища
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Створення непривілейованого користувача
RUN groupadd -r appuser && \
    useradd -r -g appuser -u 1000 -m -s /bin/bash appuser

# Встановлення залежностей в один шар
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl=7.88.1-* \
      ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Налаштування робочої директорії
WORKDIR /app

# Копіювання requirements і встановлення Python пакетів
COPY --chown=appuser:appuser requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіювання коду додатку
COPY --chown=appuser:appuser . .

# Перемикання на непривілейованого користувача
USER appuser

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl --fail http://localhost:8000/health || exit 1

# Відкриття порту (непривілейований)
EXPOSE 8000

# Команда запуску (exec form)
CMD ["python3", "-u", "app.py"]
```

---

**Дотримуйтесь цих практик для створення безпечних Docker образів! 🔒**
