#!/bin/bash

#Confirmar si se ha proporcionado un ejecutable como argumento
if [ $# -ne 1 ]; then
    echo "Escribir $0 <ejecutable>"
    exit 1
fi

#Nombre del ejecutable
executable=$1

#Nombre del archivo de registro
log_file="log.txt"

#Tiempo del muestreo en segundos
sampling_interval=1

#Función para monitorear el consumo de CPU y memoria y escribir en el archivo de registro
monitor_process() {
    #Inicializar el archivo de registro
    echo "Tiempo Consumo_CPU Consumo_Memoria" > $log_file

    #Captar el PID del proceso ejecutado
    pid=$(pgrep -x $(basename $executable) | head -n 1)

    #Monitorear el proceso mientras está en ejecución
    while [ -e /proc/$pid ]; do
        #Obtener la fecha y hora actual
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")

        #Recibir el consumo de CPU y memoria del proceso
        cpu_usage=$(ps -p $pid -o %cpu | tail -n 1)
        mem_usage=$(ps -p $pid -o %mem | tail -n 1)

        #Escribir en el archivo de registro
        echo "$timestamp $cpu_usage $mem_usage" >> $log_file

        #Esperar antes de tomar la siguiente muestra
        sleep $sampling_interval
    done

    #Generar gráfico con Gnuplot
    gnuplot <<- EOF &
        set xlabel "Tiempo"
        set ylabel "Porcentaje"
        set title "Consumo de CPU y Memoria"
        set xdata time
        set timefmt "%Y-%m-%d %H:%M:%S"
        set format x "%H:%M:%S"
        set grid
        set terminal png
        set output "graph.png"
        plot "$log_file" using 1:2 with lines title "CPU", \
             "$log_file" using 1:3 with lines title "Memoria"
EOF

    echo "Gráfico está siendo generado en segundo plano."
}

# Ejecutar el proceso proporcionado como argumento en segundo plano
$executable &

# Monitorear el proceso en segundo plano
monitor_process &

echo "El proceso está siendo monitoreado en segundo plano."
echo "Puede cerrar esta terminal o abrir otra para continuar utilizando el sistema."