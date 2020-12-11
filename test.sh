#!/bin/bash
touch logs.txt
wget https://raw.githubusercontent.com/GreatMedivack/files/master/list.out -o logs.txt
D=$(date +"%d-%m-%Y")
H=$(echo $HOSTNAME)
#1file
touch "${H}_${D}_failed".out
touch "${H}_${D}_running".out
grep -e "Error\|CrashLoopBackOff" list.out | awk '{print $1}' | grep -o "^[^-]*-\?[^-]*-\?[^-]*" > "${H}_${D}_failed".out
#2file
grep -e "Running" list.out | awk '{print $1}' | grep -o "^[^-]*-\?[^-]*-\?[^-]*" > "${H}_${D}_running".out
#3file
R=$(cat "${H}_${D}_running".out | wc -l)
E=$(cat "${H}_${D}_failed".out | wc -l)
echo "- Количество работающих сервисов:${R}" >> "${H}_${D}_report".out
echo "- Количество сервисов с ошибками:${E}" >> "${H}_${D}_report".out
echo "- Имя системного пользователя: ${USER}" >> "${H}_${D}_report".out
DD=$(date +"%d/%m/%Y")
echo "- Дата: ${DD}">> "${H}_${D}_report".out
#Архивируем
tar -cvf "${H}_${D}".tar "${H}_${D}_running".out "${H}_${D}_failed".out "${H}_${D}_report".out
#Проверяем директорию arhives
if [ -e arhives/ ];
then
cp "${H}_${D}".tar arhives/"${H}_${D}".tar
fi
#Проверка архива
if tar -xf arhives/"${H}_${D}".tar >> /dev/null
then echo "Успешно завершено"
else echo "У архива есть ошибки"
fi

#Удаление всех файлов
rm *.out *.tar *.txt