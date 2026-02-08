FROM odoo:19.0

USER root

RUN apt-get update && apt-get install -y gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt || true

COPY addons/enterprise /mnt/extra-addons/enterprise
COPY addons/custom /mnt/extra-addons/custom
RUN chown -R odoo:odoo /mnt/extra-addons

COPY entrypoint.sh /entrypoint.sh
COPY odoo.conf.template /etc/odoo/odoo.conf.template
RUN chmod +x /entrypoint.sh

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
