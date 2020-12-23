#ДАНО: Робот - в произвольной клетке поля 
#РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки 
#промакированы
#Задача 15 аналогична задаче 2, но дополнительно на поле могут находиться внутрение
# перегородки прямоугольной формы, среди которых могут быть и вырожденые прямоугольники 
#(отрезки), эти внутренние перегородки изолированы друг от друга и от внешней рамки.

function mark_frame_perimetr!(r::Robot)
    count_steps=[]
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))
        push!(count_steps,moves!(r,Sud))
    end

    side=Ost
    for _ in 1:4
        putmarkers!(r,side)
    side=next(side)
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

function moves!(r::Robot,side::HorizonSide)
     steps_st=0
     while isborder(r,side)==false
        move!(r,side)
        steps_st=steps_st+1
    end
    return steps_st
end

function moves!(r::Robot,side::HorizonSide,steps_st::Int)
    for _ in 1:steps_st 
        move!(r,side)
    end
end


function putmarkers!(r::Robot,side::HorizonSide)
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))
    

