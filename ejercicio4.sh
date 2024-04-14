#!/bin/bash
MONITORED_DIR="/home/amena/tmp" #Directorio a controlar
LOG_FILE="/home/amena/Documents/LAB2/historial.txt" #Archivo donde se registrarán los cambios

#Asegurándonos de que el comando inotifywait esté instalado
if ! command -v inotifywait &> /dev/null; then
    echo "inotifywait no está instalado. Intenta instalarlo con: sudo apt-get install inotify-tools"
    exit 1
fi

#Creación del archivo de log si no existe
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

#Monitoreo de eventos en el directorio, incluyendo renombramiento
inotifywait -m -e create -e modify -e delete -e moved_to -e moved_from --format '%w%f %e %T' --timefmt '%Y-%m-%d %H:%M:%S' "$MONITORED_DIR" | while read LINE
do
    echo "$LINE" >> "$LOG_FILE"
done