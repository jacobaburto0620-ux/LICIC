#!/bin/bash

echo "---usuario---"

#pedir nombre de usuario 
read -p "ingresa el nombre del usuario:" usuario 

#validar que no exista usuario 

id "$usuario" &>/dev/null
if [ $? -eq 0 ]; then 
	echo "El usuario ya existe"
	exit 1
fi 

#pedir contraseña
read -s -p "ingresa la contraseña del usuario: " pass
echo  "-----------"
read -s -p "Confirma la contraseña: " pass2
echo

#validar que coincidan
if [ "$pass" != "$pass2" ]; then 
	echo "las contraseñas NO coinciden"
	exit 1
fi 

# Validar longitud minima 
if [ ${#pass} -lt 6 ]; then 
	echo "La contraseña debe tener al menos 6 caracteres"
	exit 1
fi 

#Crear usuario
sudo useradd "$usuario"

#Asignar contraseña
echo "$usuario:$pass" | sudo chpasswd

echo "Usuario creado correctamente"


