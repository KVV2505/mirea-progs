#ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля
#РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так:
# нижний ряд - полностью, следующий - весь, за исключением одной последней 
#клетки на Востоке, следующий - за исключением двух последних клеток на 
#Востоке, и т.д.


#чтобы закрасить 12 клеток надо сделать 11 шагов, то есть,  количество шагов для каждой строки меньше клеток, 
#которые необходимо закрасить,на единицу 
function mark_kross!(r::Robot)
    steps_gor=moves!(r,West)
    steps_vert=moves!(r,Sud)
    side=West
    
    length_gor=gorizontal!(r,Ost) 
    
    while length_gor>0   
        putmarkers!(r,side,length_gor)
        while isborder(r,West)==false
           move!(r,West)
        end
        if (isborder(r,Nord)==false) || (isborder(r,West)==false )
            move!(r,Nord)
        end
        side=Ost
        length_gor=length_gor-1
    end
    
    if ismarker(r)==false
        putmarker!(r)
    end

    while isborder(r,Sud)==false
        move!(r,Sud)    
    end   
moves!(r,Ost,steps_gor)
moves!(r,Nord,steps_vert)
end

function gorizontal!(r::Robot,side::HorizonSide)  
    count_gor=0
    while isborder(r,Ost)==false
        move!(r,Ost) 
        count_gor=count_gor+1
    end
return count_gor    
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

function putmarkers!(r::Robot,side::HorizonSide,count_gor::Int) 
    a=count_gor
    putmarker!(r) 
    while a > 0
       move!(r,side) 
       putmarker!(r) 
       a=a-1
    end
end

 






