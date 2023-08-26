FROM odoo:latest

# switch to a root user, root is needed to run sed and write data to the volume
USER 0

# odoo seems to think using 'postgres' as the database username is a security risk, we need to remove this check
RUN sed -i -E '/\s{4}check_postgres_user\(\)/d' /usr/lib/python3/dist-packages/odoo/cli/server.py

# copy in the odoo conf file
COPY odoo.conf /etc/odoo/odoo.conf

ARG PGUSER PGPASSWORD PGHOST PGPORT PGDATABASE
ENV USER=$PGUSER PASSWORD=$PGPASSWORD HOST=$PGHOST PORT=$PGPORT

# run odoo initialize
RUN odoo -i base --stop-after-init --without-demo all --database $PGDATABASE

# start the odoo server
CMD odoo --database $PGDATABASE --http-interface "::" --http-port $PORT 2>&1