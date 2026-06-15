#!/bin/bash
clear
echo "========================================="
echo "  CHECK - Validacion TP Integral         "
echo "========================================="
ERRORES=0

# Verificar usuarios creados
echo ""
echo ">>> Verificando usuarios..."
for USER in TP_202411_Prog1 TP_202411_Prog2 TP_202411_Test1 TP_202411_Supervisor; do
  if id "$USER" > /dev/null 2>&1; then
    echo "  [OK] Usuario $USER existe"
  else
    echo "  [ERROR] Usuario $USER NO existe"
    ERRORES=$((ERRORES+1))
  fi
done

# Verificar montajes LVM
echo ""
echo ">>> Verificando montajes LVM..."
for MOUNT in /var/lib/docker /work; do
  if mountpoint -q "$MOUNT"; then
    echo "  [OK] $MOUNT esta montado"
  else
    echo "  [ERROR] $MOUNT NO esta montado"
    ERRORES=$((ERRORES+1))
  fi
done

# Verificar swap
echo ""
echo ">>> Verificando swap..."
if swapon --show | grep -q lv_swap; then
  echo "  [OK] Swap LVM activo"
else
  echo "  [ERROR] Swap LVM NO activo"
  ERRORES=$((ERRORES+1))
fi

# Verificar archivo datos.txt
echo ""
echo ">>> Verificando archivo Ansible..."
if [ -f /tmp/Grupo/datos.txt ]; then
  echo "  [OK] /tmp/Grupo/datos.txt existe"
else
  echo "  [ERROR] /tmp/Grupo/datos.txt NO existe"
  ERRORES=$((ERRORES+1))
fi

# Verificar contenedor Docker
echo ""
echo ">>> Verificando Docker..."
if sudo docker ps | grep -q "tp-div_314_grupo_quillotay"; then
  echo "  [OK] Contenedor Docker corriendo"
else
  echo "  [ERROR] Contenedor Docker NO esta corriendo"
  ERRORES=$((ERRORES+1))
fi

# Verificar URLs
echo ""
echo ">>> Verificando URLs..."
for URL in https://www.google.com https://es.wikipedia.org; do
  CODE=$(curl -o /dev/null -s -w "%{http_code}" "$URL")
  if [ "$CODE" = "200" ]; then
    echo "  [OK] $URL responde $CODE"
  else
    echo "  [WARN] $URL responde $CODE"
  fi
done

echo ""
echo "========================================="
if [ $ERRORES -eq 0 ]; then
  echo "  RESULTADO: TODO OK"
else
  echo "  RESULTADO: $ERRORES ERRORES ENCONTRADOS"
fi
echo "========================================="
