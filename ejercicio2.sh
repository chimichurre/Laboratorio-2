#!/bin/bash

#Corroborar que se proporcionen los argumentos necesarios
if [ $# -ne 2 ]; then
    echo "Escribir $0 <nombre_del_proceso> <comando_para_ejecutar>"
    exit 1
fi

#Asignar los argumentos a variables
nombre_proceso="$1"
comando="$2"

#Función para verificar y reiniciar el proceso si es necesario
verificar_proceso() {
    #Buscar el ID del proceso utilizando pgrep
    pid=$(pgrep "$nombre_proceso")

    if [ -z "$pid" ]; then
        #Si el proceso no está en ejecución, inicia el comando
        echo "El proceso '$nombre_proceso' no está en ejecución. Iniciando..."
        $comando &
    else
        echo "El proceso '$nombre_proceso' está en ejecución con PID: $pid"
    fi
}

#Loop infinito para verificar el estado del proceso periódicamente
while true; do
    verificar_proceso
    sleep 5  #Espera 5 segundos antes de revisar de nuevo
done