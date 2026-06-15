#!/bin/bash
clear
echo "========================================="
echo "  SCRIPT MASTER - TP Integral Quillotay  "
echo "========================================="

REPO_DIR=$(dirname "$0")

echo ""
echo ">>> [1/4] Ejecutando alta de usuarios..."
sed -i 's/\r//' $REPO_DIR/Bash_script/alta_usuarios/alta_usuarios.sh
sudo bash $REPO_DIR/Bash_script/alta_usuarios/alta_usuarios.sh \
  $REPO_DIR/Bash_script/alta_usuarios/Lista_Usuarios.txt vagrant

echo ""
echo ">>> [2/4] Ejecutando check de URLs..."
sed -i 's/\r//' $REPO_DIR/Bash_script/check_url/check_URL.sh
sudo bash $REPO_DIR/Bash_script/check_url/check_URL.sh \
  $REPO_DIR/Bash_script/check_url/Lista_URL.txt

echo ""
echo ">>> [3/4] Ejecutando playbook Ansible..."
cd $REPO_DIR/ansible
ansible-playbook -i inventory/hosts playbook.yml --connection=local -l testing

echo ""
echo ">>> [4/4] Levantando contenedor Docker..."
cd $REPO_DIR/docker
sudo docker-compose up -d

echo ""
echo "========================================="
echo "  SCRIPT MASTER FINALIZADO"
echo "========================================="
