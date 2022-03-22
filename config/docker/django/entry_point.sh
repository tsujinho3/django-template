#!/bin/bash

if [ ${DATABASE} = "postgres" ]
then
    echo "Waiting to run postgreSQL..."

    while ! nc -z ${SQL_HOST} ${SQL_PORT}
    do
        sleep 0.1
    done

    echo "PostgreSQL is now running..."
fi

exec $@
