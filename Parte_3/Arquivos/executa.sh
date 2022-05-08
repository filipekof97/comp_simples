#!/bin/bash

TIMEFORMAT='Tempos[ Real: %3R  User: %3U  Sys: %3S ]'

for comp in gcc clang; 
do
	for i in 0 1 2 3;
	do	
		$comp -O$i $1 $3 $4;
		
		for j in $(seq 10);
		do
			echo "---------------------------------------";
			echo "Compilacao: $comp -O$i $1 $3 $4   Parametro: $2   Execucao: $j";
			echo "Tamanho executavel:" $(du -h a.out)
			time ./a.out $2 > /etc/null				
			echo			
		done
	done
done


