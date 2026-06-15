#!/bin/bash
clear
###############################
#
# Parametros:
#  $1 - Lista de Usuarios a crear
#  $2 - Usuario del cual se obtendra la clave
#
#  Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que la del usuario pasado por parametro
#
###############################

LISTA=$1
USUARIO_REF=$2

if [ -z "$LISTA" ] || [ -z "$USUARIO_REF" ]; then
    echo "Uso: $0 <lista_usuarios> <usuario_referencia>"
    exit 1
fi

# Obtener la clave encriptada del usuario de referencia
CLAVE=$(sudo grep "^$USUARIO_REF:" /etc/shadow | cut -d: -f2)

if [ -z "$CLAVE" ]; then
    echo "Error: no se pudo obtener la clave del usuario $USUARIO_REF"
    exit 1
fi

ANT_IFS=$IFS
IFS=$'\n'

for LINEA in $(cat $LISTA | grep -v ^#)
do
    USUARIO=$(echo $LINEA | awk -F ',' '{print $1}')
    GRUPO=$(echo $LINEA | awk -F ',' '{print $2}')
    HOME=$(echo $LINEA | awk -F ',' '{print $3}')

    # Crear grupo si no existe
    if ! getent group "$GRUPO" > /dev/null 2>&1; then
        sudo groupadd "$GRUPO"
        echo "Grupo creado: $GRUPO"
    fi

    # Crear directorio home si no existe
    sudo mkdir -p "$HOME"

    # Crear usuario si no existe
    if ! id "$USUARIO" > /dev/null 2>&1; then
        sudo useradd -m -s /bin/bash -g "$GRUPO" -d "$HOME" "$USUARIO"
        # Asignar la misma clave que el usuario de referencia
        sudo usermod -p "$CLAVE" "$USUARIO"
        echo "Usuario creado: $USUARIO | Grupo: $GRUPO | Home: $HOME"
    else
        echo "Usuario ya existe: $USUARIO"
    fi
done

IFS=$ANT_IFS
