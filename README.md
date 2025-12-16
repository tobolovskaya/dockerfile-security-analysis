# 🐳 Dockerfile Security Analysis Lab

> **Лабораторна робота з аналізу безпеки Dockerfile за допомогою GitLab CI/CD**

[![GitLab CI/CD](https://img.shields.io/badge/GitLab-CI%2FCD-orange?logo=gitlab)](https://gitlab.com)
[![Docker](https://img.shields.io/badge/Docker-Security-blue?logo=docker)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-Educational-green)](#)

---

## 🚀 Швидка навігація

| Документ | Призначення | Час читання |
|----------|-------------|-------------|
| [⚡ QUICK_START.md](QUICK_START.md) | Почніть за 5 хвилин | 5 хв |
| [📚 INDEX.md](INDEX.md) | Повна навігація | 10 хв |
| [📋 SUBMISSION_CHECKLIST.md](SUBMISSION_CHECKLIST.md) | Контрольний список здачі | 5 хв |
| [🔍 COMPARISON.md](COMPARISON.md) | Порівняння Docker-bad vs Docker-good | 10 хв |
| [💡 CONCLUSIONS.md](CONCLUSIONS.md) | Відповіді на питання | 20 хв |
| [📝 ANALYSIS.md](ANALYSIS.md) | Повний звіт | 30 хв |
| [🔒 SECURITY_CHECKLIST.md](SECURITY_CHECKLIST.md) | Чеклист безпеки | 15 хв |

---

## 📁 Структура проєкту

```
├── .gitlab-ci.yml    # Конфігурація CI/CD pipeline
├── Docker-bad        # Небезпечний Dockerfile (з вразливостями)
├── Docker-good       # Безпечний Dockerfile (виправлений)
├── ANALYSIS.md       # Детальний звіт про аналіз
└── README.md         # Цей файл
```

## 🚀 Швидкий старт

### 1. Створення проєкту в GitLab

1. Увійдіть у GitLab
2. Створіть новий проєкт "docker-security"
3. Завантажте файли з цього репозиторію

### 2. Тестування Docker-bad

```bash
# Перейменуйте Docker-bad на Dockerfile
git mv Docker-bad Dockerfile
git add Dockerfile .gitlab-ci.yml
git commit -m "Test Docker-bad"
git push
```

Перейдіть у розділ **CI/CD → Pipelines** і подивіться на результати.

### 3. Тестування Docker-good

```bash
# Замініть Dockerfile на Docker-good
git mv Docker-good Dockerfile
git add Dockerfile
git commit -m "Test Docker-good"
git push
```

## 🔍 Інструменти аналізу

### Hadolint
- **Призначення**: Лінтинг Dockerfile
- **Що перевіряє**: Синтаксис, стиль, best practices

### Trivy
- **Призначення**: Сканування безпеки
- **Що перевіряє**: Конфігураційні вразливості, відсутність безпекових налаштувань

### Dockle
- **Призначення**: Аудит best practices
- **Що перевіряє**: CIS Docker Benchmark, оптимізація, production-готовність

## 📊 Очікувані результати

### Docker-bad (❌ Не пройде перевірки)

- Hadolint: ⚠️ Попередження про ADD, apt-get без прапорців
- Trivy: ❌ Критичні проблеми (запуск від root)
- Dockle: ❌ Порушення CIS benchmarks

### Docker-good (✅ Пройде всі перевірки)

- Hadolint: ✅ Без помилок
- Trivy: ✅ Без вразливостей
- Dockle: ✅ Відповідає стандартам

## 📝 Основні проблеми безпеки в Docker-bad

1. ⚠️ **Запуск від root** - критичний ризик
2. ⚠️ **Відсутність HEALTHCHECK** - проблеми з моніторингом
3. ⚠️ **ADD замість COPY** - непередбачувана поведінка
4. ⚠️ **Відсутність --no-install-recommends** - зайві пакети
5. ⚠️ **Не видалено apt кеш** - збільшення розміру

## ✅ Виправлення в Docker-good

1. ✅ Використання slim-образу (debian:12.5-slim)
2. ✅ Створення непривілейованого користувача
3. ✅ Додано HEALTHCHECK
4. ✅ COPY замість ADD
5. ✅ Очищення apt кешу
6. ✅ Використання --no-install-recommends

## 🧪 Локальне тестування

```bash
# Hadolint
docker run --rm -i hadolint/hadolint < Dockerfile

# Trivy
docker run --rm -v $PWD:/mnt aquasec/trivy config /mnt/Dockerfile

# Dockle (спочатку побудуйте образ)
docker build -t test-image .
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle test-image
```

## 📚 Додаткові матеріали

- [Детальний звіт про аналіз](ANALYSIS.md)
- [Hadolint Rules](https://github.com/hadolint/hadolint#rules)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [Dockle Checkpoints](https://github.com/goodwithtech/dockle#checkpoint-summary)

## 🎯 Висновки

Автоматизована перевірка безпеки Dockerfile є критично важливою для:
- Виявлення вразливостей на ранніх стадіях
- Дотримання industry best practices
- Забезпечення production-готовності контейнерів
- Зменшення поверхні атаки

---

**Автор**: Yevheniia Tobolovska  
**Дата**: Грудень 2025
