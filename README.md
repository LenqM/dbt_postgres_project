## Sprawozdanie z projektu: Budowa Modeli Danych i Procesu ELT z Wykorzystaniem dbt, baza docelowa duckdb

Projekt zakładał uruchomienie środowiska analityczno-transformacyjnego na instancji AWS EC2. Na tej instancji uruchomione zostały dwa kontenery Docker: pierwszy z bazą danych PostgreSQL (pełniącą rolę źródła danych), drugi z interfejsem VS Code dostępnym przez przeglądarkę (port 8888), w którym znajdowało się skonfigurowane środowisko z narzędziami **DBT**, **DuckDB** 

Komunikacja między kontenerami odbywała się przez sieć Docker, umożliwiając odwoływanie się do bazy PostgreSQL po nazwie kontenera bez konieczności podawania adresu IP.

Dane źródłowe pochodziły z przykładowej bazy danych **sakila**, zawierającej informacje o filmach, aktorach i wypożyczeniach. Zostały one zeskanowane do DuckDB z użyciem funkcji `postgres_scan` - użytej w modelach stg, która pozwoliła traktować tabele PostgreSQL jako źródła danych bez uprzedniego kopiowania.

W projekcie utworzono projekt DBT o nazwie `dbt_postgres_project`, skonfigurowany do pracy z **DuckDB** jako docelową bazą danych. W ramach projektu wykonano transformacje danych – utworzono modele stagingowe (`stg_*`) oraz tabelę faktu (`fct_rental`). Modele zostały przetestowane przy użyciu wbudowanych testów DBT (`unique`, `not_null`) oraz testów własnych.

Po wykonaniu `dbt run`, `dbt test` i `dbt docs generate` uruchomiono `dbt docs serve`, by wygenerować i otworzyć dokumentację projektu wraz z graficznym przedstawieniem transformacji.
---

## Instrukcja instalacji komponentów na EC2

1. Uruchomienie infrastruktury AWS poprzez terraform - folder /infra, z odpowiednio zmienioną nazwą bucketa na własną.
1a. Utworzenie tunelu ssh poprzez komendę:
ssh -N -f -L 8888:localhost:8888 -L 8080:localhost:8080 -L 8000:localhost:8000 -i ~/Downloads/kp.pem ec2-user@${aws_instance.lab_instance.public_ip}

2. **Uruchomienie kontenerów na EC2**:
Dostęp do konsoli na EC2 poprzez komendę: 
ssh -i ~/Downloads/kp.pem ec2-user@${aws_instance.lab_instance.public_ip}

   * Kontener z PostgreSQL (losowo nadawane nazwy, np. brave_snyder) na porcie 5432. - pobranie i uruchomienie wg. instrukcji README.md - https://github.com/sakiladb/postgres/blob/master/README.md
   * Kontener z VS Code Server + zainstalowane dbt (vs) z otwartym portem **8888** - instalacja automatyczna ze skryptu startup.sh

3. **Instalacja postgresa i wtyczki dbt-postgres** wewnątrz kontenera VS Code:

   ```bash
    sudo yum clean metadata
    sudo yum install postgresql postgresql-server postgresql-contrib -y

    python3 -m venv dbt-env
    source dbt-env/bin/activate
    pip install --upgrade pip
    pip install dbt-postgres

   ```

Dzięki tej konfiguracji, możliwe było lokalne korzystanie z interfejsów VS Code (`localhost:8888`) oraz narzędzi DBT i przesyłu danych postgres-duckdb poprzez DBT w zintegrowanym środowisku analitycznym.
