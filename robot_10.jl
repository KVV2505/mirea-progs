#ДАНО: Робот - в юго-западном углу поля, на котором расставлено некоторое количество маркеров
#РЕЗУЛЬТАТ: Функция вернула значение средней температуры всех замаркированных клеток
function mark_temp(r::Robot) #вывод средней температуры
    moves!(r)
    count_mark,summ_temp = sum_temperatures(r)
return summ_temp/count_mark
end

function sum_temperatures(r::Robot)
    side=Ost
    count_mark=0
    summ_temp=0
    while isborder(r,Nord)==false     #cуммирование температуры и количества пока не достигнет конечного положения 
        count_mark1,summ_temp1=count!(r,side)
        count_mark=count_mark+count_mark1
        summ_temp=summ_temp+summ_temp1
        move!(r,Nord)
        side=inverse(side)
    end
count_mark1,summ_temp1=count!(r,side)
count_mark=count_mark+count_mark1
summ_temp=summ_temp+summ_temp1
return count_mark , summ_temp
end

function count!(r::Robot,side::HorizonSide)  #считает кол-во маркеров и суммарную температуру на каждой строке отдельно
    count_mark=0 
    summ_temp=0
    while isborder(r,side)==false
        if ismarker(r)==true
            count_mark=count_mark+1
            summ_temp=summ_temp+temperature(r)
        end
        move!(r,side)
    end
return count_mark, summ_temp
end

function moves!(r::Robot)
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    while isborder(r,West)==false
        move!(r,West)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  


