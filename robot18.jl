#Задача  18 аналогична задаче 5, но дополнительно на поле могут 
#находиться внутрение перегородки прямоугольной формы, среди которых могут 
#быть и вырожденые прямоугольники (отрезки), эти внутренние перегородки 
#изолированы друг от друга и от внешней рамки.
#ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, 
#на котором могут находиться также внутренние прямоугольные перегородки
#(все перегородки изолированы друг от друга, прямоугольники могут 
#вырождаться в отрезки)
#РЕЗУЛЬТАТ: Робот - в исходном положении и в углах поля стоят маркеры


#задача 18 абсолютно такая же,как и 5

function mark_angle!(r::Robot)
    count_steps=[]
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))
        push!(count_steps,moves!(r,Sud))
    end
    
    for side in (Ost,Nord,West,Sud)
        putmarkers!(r,side)
    end

    for (i,n) in enumerate(reverse!(count_steps))  #массив наоборот, с последнего шага до первого
        #пары индекс-значение элементов (индексу i соответствует значение n)
        if isodd(i)==true   #нечетный    
           side=Nord  #Сначала запад, потом юг...массив перевенули, т. е сначала юг,потом запад
        else
           side=Ost
        end
        moves!(r,side,n)  
    end
end

function putmarkers!(r::Robot,side::HorizonSide)
    putmarker!(r)
    while isborder(r,side)==false 
        move!(r,side)
    end
end
    
function moves!(r::Robot,side::HorizonSide)
    steps=0
    while isborder(r,side)==false
        move!(r,side)
        steps=steps+1
    end 
return steps
end

function moves!(r::Robot,side::HorizonSide,num_steps::Int)
    for _ in 1:num_steps
        move!(r,side)
    end
end