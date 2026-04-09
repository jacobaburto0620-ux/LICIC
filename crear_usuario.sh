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

#Creat cuotas 
read -p "¿Dese asignar cuota ? S/N :" opcion
 
if [ "$opcion" = "s" ]; then 

	read -p "Soft limit (KB): " soft
	read -p "Hard limit (KB):" hard

	if [ "$soft" -ge "$hard" ]; then 
		echo "El soft limit debe ser menor que el hard limit"
		exit 1
	fi

	#aplicar cuota 
	sudo setquota -u "$usuario" $soft $hard 0 0 /

	echo "Cuota asignada"

	read -p "¿Cambiar periodo de gracia? s/n " gracia 

	if [ "$gracia" = "s" ]; then 
		read -p "dias de gracia: " dias

		sudo setquota -t $dias $dias /

		echo "Periodo de gracia actualizado"
	fi
fi

# SUDO
read -p " ¿Deseas dar permisos sudo (s/n) : " sudo_opp
if [ "$sudo_opp" = "s" ]; then 

	echo "1) Todos los comandos"
	echo "2) Solo un comando"
	read -p "Elige la opcion: " tipo

	if [ "$tipo" = "1" ]; then 
		sudo  usermod -aG sudo "$usuario"
		echo "usuario agregado a sudo"
	elif [ "$tipo" = "2" ]; then 
		read -p "Escribe el comando  " comando

		echo "$usuario ALL=(ALL) NOPASSWD: $comando" | sudo tee -a /etc/sudoers

		echo "permiso asignado para comando especifico"
	fi
fi
echo "terminamos"
