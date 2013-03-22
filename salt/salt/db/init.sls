postgresql:
    pkg:
        - installed
    service:
        - running
        - require:
            - pkg: postgresql

vagrant:
    postgres_user:
        - present
        - createdb: True
        - createuser: False
        - superuser: False
        - runas: postgres
        - require:
            - pkg: postgresql
    postgres_database:
        - present
        - owner: vagrant
        - require:
            - pkg: postgresql
            - postgres_user: vagrant

