#!/bin/bash
clear
###############################
#
# Parametros:
#  $1 - Lista Dominios y URL
#
#  Tareas:
#  - Recorre la lista de URLs y verifica su estado HTTP
#  - Genera logs en /var/log/status_url.log
#
###############################

LISTA=$1
LOG_FILE="/var/log/status_url.log"

if [ -z "$LISTA" ]; then
    echo "Uso: $0 <lista_urls>"
    exit 1
fi

# Crear archivo de log si no existe
sudo touch "$LOG_FILE"

ANT_IFS=$IFS
IFS=$'\n'

for LINEA in $(cat $LISTA | grep -v ^#)
do
    DOMINIO=$(echo $LINEA | awk '{print $1}')
    URL=$(echo $LINEA | awk '{print $2}')

    # Obtener el código de estado HTTP
    STATUS_CODE=$(curl -LI -o /dev/null -w '%{http_code}\n' -s "$URL")

    # Fecha y hora actual en formato yyyymmdd_hhmmss
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

    # Registrar en el archivo de log
    echo "$TIMESTAMP - Code:$STATUS_CODE - Dominio:$DOMINIO - URL:$URL" | sudo tee -a "$LOG_FILE"
done

IFS=$ANT_IFS
