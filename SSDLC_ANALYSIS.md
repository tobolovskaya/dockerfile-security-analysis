# Аналіз безпеки Dockerfile у GitLab CI/CD: SSDLC та DevSecOps

**Студент:** Yevheniia Tobolovska  
**Дата:** 16 грудня 2025  
**Дисципліна:** Безпека програмного забезпечення

---

## 🎯 Мета аналізу

Закріпити практичні навички безпечної роботи з контейнерними середовищами та CI/CD-процесами через:
- Розпізнавання типових ризиків у Dockerfile
- Пояснення ролі інструментів автоматичного аналізу (Hadolint, Trivy, Dockle)
- Зіставлення знайдених проблем з принципами SSDLC
- Формулювання технічних рекомендацій для безпечної розробки контейнерів

---

## 📊 Порівняльна таблиця результатів аналізу

### Hadolint (Dockerfile Linter)

| № | Типи ризиків (Docker-bad) | Як виправлено (Docker-good) | Принципи SSDLC / Best Practices | Критичність |
|---|---|---|---|---|
| 1 | **DL3020**: Використання ADD замість COPY для локальних файлів | Заміна `ADD . /app` на `COPY . /app` | **Principle of Least Surprise**: COPY має передбачувану поведінку, ADD автоматично розпаковує архіви | Medium |
| 2 | **DL3008**: Відсутність фіксації версій пакетів `apt-get install -y curl` | Фіксація версій: `curl=7.88.1-*` (хоча в Docker-good не показано для простоти) | **Supply Chain Security**: Контрольовані залежності запобігають неочікуваним змінам | Medium |
| 3 | **DL3009**: Не видалено apt кеш після встановлення пакетів | `apt-get clean && rm -rf /var/lib/apt/lists/*` | **Minimization**: Зменшення поверхні атаки та розміру образу | Low |
| 4 | **DL3015**: Виявлення потенційного `apt-get upgrade` (порушення best practice) | Уникнення upgrade команд в контейнерах | **Immutable Infrastructure**: Контейнери мають бути незмінними | Medium |
| 5 | **DL3025**: Використання shell form замість exec form в CMD | `CMD ["curl", "--version"]` замість `CMD ["bash", "start.sh"]` | **Process Management**: Правильна обробка сигналів операційної системи | Low |

### Trivy (Security Scanner)

| № | Типи ризиків (Docker-bad) | Як виправлено (Docker-good) | Принципи SSDLC / Best Practices | Критичність |
|---|---|---|---|---|
| 1 | **Running as root user**: Контейнер працює з максимальними привілеями | `RUN useradd -m -s /bin/bash safeuser` + `USER safeuser` | **Principle of Least Privilege**: Мінімальні необхідні права доступу | High |
| 2 | **Missing HEALTHCHECK**: Неможливість автоматичного моніторингу стану | `HEALTHCHECK --interval=30s --timeout=10s CMD curl --fail ...` | **Observability**: Моніторинг стану системи в runtime | Medium |
| 3 | **Unsafe apt-get usage**: Встановлення без `--no-install-recommends` | `apt-get install -y --no-install-recommends` | **Attack Surface Reduction**: Мінімізація встановлених компонентів | Low |
| 4 | **Large base image (ubuntu:22.04)**: Збільшена поверхня атаки | Використання `debian:12.5-slim` | **Minimization**: Зменшення кількості потенційних вразливостей | Medium |
| 5 | **Exposed privileged port (80)**: Порт потребує root привілеїв | Порт не експонується в безпечній версії або використання >1024 | **Least Privilege**: Уникнення привілейованих ресурсів | Medium |

### Dockle (CIS Docker Benchmark)

| № | Типи ризиків (Docker-bad) | Як виправлено (Docker-good) | Принципи SSDLC / Best Practices | Критичність |
|---|---|---|---|---|
| 1 | **CIS-DI-0001**: Create a user for the container | `RUN useradd -m -s /bin/bash safeuser` + `USER safeuser` | **CIS Benchmark 4.1**: Контейнери не повинні працювати як root | High |
| 2 | **CIS-DI-0006**: Add HEALTHCHECK instruction to container image | `HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD ...` | **CIS Benchmark 4.6**: Моніторинг здоров'я контейнера | Medium |
| 3 | **DKL-DI-0005**: Clear apt-get lists after installing packages | `apt-get clean && rm -rf /var/lib/apt/lists/*` | **Image Optimization**: Зменшення розміру та кешів | Low |
| 4 | **CIS-DI-0010**: Do not store secrets in Dockerfiles | Відсутність секретів в образі (в обох версіях дотримано) | **Secrets Management**: Зовнішнє управління секретами | High |
| 5 | **DKL-LI-0001**: Avoid sudo command | Використання непривілейованого користувача замість sudo | **Privilege Separation**: Розділення привілеїв | Medium |

---

## 🔍 Аналітичний опис

### Типи проблем, що найчастіше зустрічалися

Найбільш критичною та поширеною проблемою є **запуск контейнерів від імені root користувача** (виявлено всіма трьома інструментами з рівнем High). Це порушує фундаментальний принцип Least Privilege та створює максимальний ризик при компрометації контейнера. Другою за частотою є **відсутність HEALTHCHECK**, що ускладнює моніторинг та автоматичне відновлення сервісів в production-середовищах.

### Роль CI/CD в попередженні вразливостей

Автоматизація CI/CD з інтегрованими інструментами статичного аналізу забезпечує **shift-left security** - виявлення проблем на найранніших стадіях розробки. GitLab pipeline з `allow_failure: false` для критичних перевірок створює **security gate**, що фізично блокує деплой небезпечних образів. Це реалізує принцип **fail-fast** та забезпечує, що лише код, який пройшов всі перевірки безпеки, потрапляє в production.

### Обов'язкові рекомендації для production

Для production-середовища критично важливими є: створення непривілейованого користувача, додавання HEALTHCHECK для orchestration систем (Kubernetes/Docker Swarm), використання slim базових образів, та фіксація версій всіх залежностей. Ці практики мінімізують **blast radius** при інцидентах безпеки та забезпечують передбачуваність поведінки системи.

---

## 📝 Відповіді на аналітичні питання

### 1. Які типи помилок виявив Hadolint і чому їх важливо усувати ще до побудови контейнера?

**Hadolint виявив наступні типи помилок:**
- **DL3020** (ADD vs COPY): ADD має додаткову функціональність автоматичного розпакування архівів, що може призвести до непередбачуваної поведінки
- **DL3008** (Version pinning): Відсутність фіксації версій пакетів може призвести до різної поведінки образу в різний час
- **DL3009** (Cache cleaning): Залишення кешу збільшує розмір образу та потенційну поверхню атаки
- **DL3025** (Exec vs Shell form): Shell form не передає сигнали правильно до процесу

**Чому важливо усувати до побудови:**
1. **Економія ресурсів**: Виправлення на етапі написання коду дешевше в 100 разів, ніж після деплою
2. **Якість образу**: Запобігання створенню образів з вбудованими проблемами
3. **Стандартизація**: Забезпечення дотримання корпоративних стандартів кодування

### 2. Чим результати Trivy відрізняються від Dockle у контексті оцінки ризиків?

| Аспект | Trivy | Dockle |
|--------|-------|---------|
| **Фокус** | Configuration Security + Vulnerabilities | CIS Docker Benchmark Compliance |
| **Типи перевірок** | Конфігураційні вразливості, CVE в залежностях | Відповідність industry standards (CIS) |
| **Глибина аналізу** | Аналізує як Dockerfile, так і content образу | Фокус на Dockerfile та image metadata |
| **Практичність** | Виявляє реальні security issues | Забезпечує compliance та best practices |
| **Критерії оцінки** | Security impact (High/Medium/Low) | CIS benchmark requirements (Pass/Fail) |

**Trivy** більше орієнтований на виявлення **реальних вразливостей**, тоді як **Dockle** перевіряє **відповідність стандартам**. Trivy відповідає на питання "Чи безпечний цей образ?", а Dockle - "Чи відповідає цей образ industry best practices?".

### 3. Як принцип Least Privilege реалізується в Dockerfile і як це впливає на безпеку?

**Реалізація Least Privilege в Dockerfile:**

```dockerfile
# ❌ Docker-bad: порушення принципу
FROM ubuntu:22.04
# Запуск як root (UID 0) з максимальними правами
CMD ["bash", "start.sh"]

# ✅ Docker-good: дотримання принципу  
FROM debian:12.5-slim
RUN useradd -m -s /bin/bash safeuser  # Створення користувача з мінімальними правами
USER safeuser                          # Перемикання на непривілейованого користувача
WORKDIR /home/safeuser                 # Робота в домашній директорії користувача
CMD ["curl", "--version"]              # Виконання з правами safeuser
```

**Вплив на безпеку:**
1. **Container Escape Mitigation**: При компрометації процесу зловмисник отримує лише права користувача, а не root
2. **Host System Protection**: Обмежується можливість впливу на host систему через mount points
3. **Lateral Movement Prevention**: Зменшується можливість переходу до інших контейнерів або сервісів
4. **Audit Trail**: Дії непривілейованого користувача краще відстежуються системами логування

### 4. Які перевірки можна автоматизувати у GitLab CI/CD, щоб не допустити повторення помилок?

**Pipeline Configuration для автоматизації:**

```yaml
stages:
  - static-analysis
  - security-scan
  - compliance-check
  - deployment-gate

# 1. Статичний аналіз коду
dockerfile-lint:
  stage: static-analysis
  script:
    - hadolint Dockerfile
  allow_failure: false  # Блокує pipeline при помилках

# 2. Сканування безпеки
security-scan:
  stage: security-scan
  script:
    - trivy config --severity HIGH,CRITICAL --exit-code 1 Dockerfile
    - trivy fs --security-checks vuln .
  allow_failure: false

# 3. Перевірка compliance
compliance-check:
  stage: compliance-check
  script:
    - docker build -t temp-image .
    - dockle --exit-code 1 temp-image
  allow_failure: false

# 4. Quality gates
deployment-gate:
  stage: deployment-gate
  script:
    - echo "All security checks passed"
  only:
    - main
    - production
```

**Додаткові автоматизовані перевірки:**
- **Pre-commit hooks**: Hadolint перевірки перед commit
- **Merge Request validation**: Блокування MR з security issues
- **Scheduled scans**: Регулярне сканування на нові CVE
- **Policy as Code**: OPA/Gatekeeper правила для Kubernetes

### 5. Як інструменти статичного аналізу допомагають на етапах "Design" і "Implementation" SSDLC?

#### Етап "Design" (Проєктування):

**Роль статичного аналізу:**
- **Threat Modeling Integration**: Hadolint rules можуть бути інтегровані в процес threat modeling
- **Security Requirements Definition**: Dockle CIS benchmarks допомагають визначити security requirements
- **Architecture Decisions**: Trivy допомагає обрати безпечні базові образи на етапі архітектурних рішень

**Приклад інтеграції в Design:**
```yaml
# Файл: security-requirements.yml
dockerfile_security_requirements:
  base_images:
    - allowed: ["debian:*-slim", "alpine:*", "distroless/*"]
    - forbidden: ["ubuntu:latest", "*:latest"]
  user_requirements:
    - must_create_non_root_user: true
    - must_switch_to_non_root: true
  health_monitoring:
    - healthcheck_required: true
```

#### Етап "Implementation" (Реалізація):

**Shift-Left Security:**
- **IDE Integration**: Real-time feedback під час написання Dockerfile
- **Git Hooks**: Pre-commit перевірки перед додаванням коду в repository
- **Continuous Feedback**: Швидкий feedback loop для розробників

**Практичний приклад:**
```bash
# Pre-commit hook
#!/bin/sh
echo "Running Dockerfile security checks..."
hadolint Dockerfile || exit 1
trivy config Dockerfile || exit 1
echo "✅ Security checks passed"
```

**Переваги для SSDLC:**

| Етап SSDLC | Інструмент | Переваги |
|------------|------------|----------|
| **Design** | Dockle CIS Rules | Визначення security baseline на етапі проєктування |
| **Design** | Trivy Policy Checks | Вибір безпечних компонентів та конфігурацій |
| **Implementation** | Hadolint | Real-time guidance для розробників |
| **Implementation** | All Tools | Automated security testing в CI/CD |
| **Testing** | Integration Tests | Автоматичне тестування security properties |
| **Deployment** | Policy Gates | Запобігання деплою небезпечних артефактів |

---

## 📈 Висновки щодо ролі статичних аналізаторів у SSDLC

### Роль статичних аналізаторів у SSDLC

Статичні аналізатори безпеки (Hadolint, Trivy, Dockle) є **критично важливими компонентами** Secure Software Development Lifecycle, що забезпечують:

1. **Early Detection**: Виявлення проблем безпеки на етапі розробки, коли їх виправлення коштує найменше
2. **Automated Governance**: Автоматичне забезпечення дотримання security policies без людського втручання
3. **Knowledge Transfer**: Навчання розробників через automated feedback та пояснення помилок
4. **Consistent Standards**: Забезпечення однакових стандартів безпеки в усій організації

### Типові проблеми, які можна виявити автоматично

**Категорії автоматично виявлених проблем:**

| Категорія | Приклади | Інструменти |
|-----------|----------|-------------|
| **Configuration Issues** | Root user, missing HEALTHCHECK, privileged ports | Trivy, Dockle |
| **Best Practice Violations** | ADD vs COPY, cache management, pinning versions | Hadolint |
| **Compliance Violations** | CIS benchmark deviations, security standards | Dockle |
| **Supply Chain Risks** | Untrusted base images, unpinned dependencies | Trivy, Hadolint |
| **Operational Security** | Missing monitoring, improper signal handling | All tools |

### Значення комбінованого підходу

**Синергетичний ефект трьох інструментів:**

1. **Повне покриття**: Hadolint (syntax/style) + Trivy (security) + Dockle (compliance) = 100% coverage
2. **Різні перспективи**: Developer experience + Security engineering + Operations requirements
3. **Graduated Response**: Різні рівні критичності дозволяють поступове впровадження
4. **Defense in Depth**: Multiple layers of security validation

**Приклад комбінованої стратегії:**
```yaml
# Поетапне впровадження з різним allow_failure
hadolint:
  allow_failure: true   # Навчання та адаптація команди
  
trivy:
  allow_failure: false  # Блокування критичних security issues
  
dockle:
  allow_failure: true   # Поступове покращення compliance
```

### Інтеграція з DevSecOps

**Ключові принципи інтеграції:**

1. **Automation First**: Всі перевірки мають бути автоматизованими
2. **Fail Fast**: Швидке виявлення та повідомлення про проблеми
3. **Continuous Improvement**: Постійне оновлення правил та політик
4. **Developer Experience**: Мінімізація friction при збереженні безпеки

**Практичні рекомендації для впровадження:**

- Розпочинати з `allow_failure: true` для адаптації команди
- Поступово переходити до `allow_failure: false` для критичних перевірок
- Інтегрувати з IDE для real-time feedback
- Регулярно оновлювати правила відповідно до нових загроз
- Проводити навчання команди з інтерпретації результатів

---

## 🎯 Практичне значення для DevSecOps

Даний аналіз демонструє, як автоматизація security testing в CI/CD pipeline забезпечує **shift-left security** - перенесення перевірок безпеки на ранні етапи розробки. Комбінація Hadolint, Trivy та Dockle створює **multi-layered security validation**, що відповідає принципам defense-in-depth та забезпечує високий рівень безпеки контейнерних додатків при мінімальному впливі на швидкість розробки.

---

**Дата підготовки:** 16 грудня 2025  
**Студент:** Yevheniia Tobolovska  
