#!/bin/bash

#CONSTATAR que se haya proporcionado un argumento
if [ $# -ne 1 ]; then
    echo "Uso: $0 <PID>"
    exit 1
fi

#Obtener el PID del argumento
pid=$1

#Confirmar si el PID es un número
if ! [[ $pid =~ ^[0-9]+$ ]]; then
    echo "El argumento debe ser un número entero."
    exit 1
fi

#Verificar si el proceso con el PID proporcionado existe
if ! ps -p $pid >/dev/null 2>&1; then
    echo "El proceso con PID $pid no existe."
    exit 1
fi

#Conseguir la información del proceso
nombre=$(ps -p $pid -o comm=)
ppid=$(ps -p $pid -o ppid=)
usuario=$(ps -p $pid -o user=)
cpu=$(ps -p $pid -o %cpu=)
memoria=$(ps -p $pid -o %mem=)
estado=$(ps -p $pid -o state=)
path=$(readlink /proc/$pid/exe)

#Desplegar la información obtenida
echo "a) Nombre del proceso: $nombre"
echo "b) ID del proceso: $pid"
echo "c) Parent process ID: $ppid"
echo "d) Usuario propietario: $usuario"
echo "e) Porcentaje de uso de CPU: $cpu"
echo "f) Consumo de memoria: $memoria"
echo "g) Estado (status): $estado"
echo "h) Path del ejecutable: $path"
