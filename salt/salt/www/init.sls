nginx:
    pkg:
        - installed
    service:
        - running
        - require:
            - pkg: nginx
        - watch:
            - file: /etc/nginx/sites-enabled/*
