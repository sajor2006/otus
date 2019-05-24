#!/bin/bash

loc=/tmp/loc
parTmp=/tmp/pars.tmp
log=/var/log/httpd/privratnik.net.log #log apache
LANG=en_US.UTF-8 #Уставливаем локаль, действует до окнчания сессии.

if ( set -o noclobber; echo "$$" > "$loc") 2>/dev/null; then
	trap 'rm -f "$loc"; exit $?' INT TERM EXIT





	if [ -f $parTmp ]; then
			sed -i '1d' $parTmp  #удаляем первую строку файла
			#считываем последнюю строку log файла, чтоб запомнить где закнчиваем парсить log. Еще можно так считать sed -n '$p' # способ 2 
			sed -e '$!d' -e 's/\]/\] - /' $log |awk -F"-" '{print $3}' |sed -e 's/\]//' -e 's/\[//' -e 's/:/ /' -e 's/\// /g' -e '0,/\ +..../s///' -e 's/^ //' -e 's/ $//'>>$parTmp
		else 
			#считываем первую строку файла 'head -1' == sed q так как моя модель парсера требует начала и конца 
			sed -e 's/\]/\] - /' -e q $log |awk -F"-" '{print $3}' |sed -e 's/\]//' -e 's/\[//' -e 's/:/ /' -e 's/\// /g' -e '/\ +..../s///' -e 's/^ //' -e 's/ $//'>$parTmp

			#считываем последнюю строку файла, чтоб запомнить где закнчиваем парсить лог. Еще можно так считать sed -n '$p' # способ 2 
			sed -e '$!d' -e 's/\]/\] - /' $log |awk -F"-" '{print $3}' |sed -e 's/\]//' -e 's/\[//' -e 's/:/ /' -e 's/\// /g' -e '0,/\ +..../s///' -e 's/^ //' -e 's/ $//'>>$parTmp
		fi

		date1=`sed q $parTmp`
		date2=`sed '$!d' $parTmp`

echo from $date1 to $date2

#парсим в предлах двух дат, так как пока будут выполнтся следующие проходы по логу, первые могут стать уже не актуальными, вторая дата не даст этого допустить.
echo ip
nice -n 20 awk -vDate1=`date -d"$date1" +[%d/%b/%Y:%H:%M:%S` -vDate2=`date -d"$date2" +[%d/%b/%Y:%H:%M:%S` '$4 > Date1 && $4 < Date2 {print $0}' $log | awk -F\" '{print $1}' | awk '{print $1}' | sort | uniq -c | sort -nr
echo pages
nice -n 20 awk -vDate1=`date -d"$date1" +[%d/%b/%Y:%H:%M:%S` -vDate2=`date -d"$date2" +[%d/%b/%Y:%H:%M:%S` '$4 > Date1 && $4 < Date2 {print $0}' $log | awk -F\" '{print $2}' | awk '{print $2}' | sort | uniq -c | sort -nr
echo code
nice -n 20 awk -vDate1=`date -d"$date1" +[%d/%b/%Y:%H:%M:%S` -vDate2=`date -d"$date2" +[%d/%b/%Y:%H:%M:%S` '$4 > Date1 && $4 < Date2 {print $0}' $log | awk -F\" '{print $3}' | awk '{print $1}' | sort | uniq -c | sort -nr



else
	echo 'started'
fi
