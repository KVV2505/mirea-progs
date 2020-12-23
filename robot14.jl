#Задачи 14 aналогична задачае 1, но
#дополнительно на поле могут находиться внутрение
#перегородки прямоугольной формы, среди которых могут 
#быть и вырожденые прямоугольники (отрезки), эти внутренние 
#перегородки изолированы друг от друга и от внешней рамки. 
#ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
#РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.

function mark_cross!(r::Robot)
    for side in(Nord,West,Sud,Ost)
        num_steps=putmarkers!(r,side)
        detour!(r,side)
        ort_side=next(side)
        inv_side=inverse(ort_side)
        while ismarker(r)==false
            move!(r,inv_side)
        end
        move_by_marker!(r,inverse(side),num_steps)
    end
putmarker!(r)
end

function putmarkers!(r::Robot,side::HorizonSide) #работает пока не достигнута верхняя граница
    num_steps=0
    while (detour!(r, side)==true) 
        putmarker!(r)
        num_steps+=1 #кол-во маркеров 
    end     
    return num_steps
end

function detour!(r::Robot,side::HorizonSide)::Bool
next_side=next(side) #сторона, перпендикулярная исходной (для севера-запад и тд)
inv_next_side=inverse(next_side) #для возврата (для севера это будет восток)
count_steps=0
    while (isborder(r,side)==true) 
        if isborder(r, next_side) == false #или угол или конец перегородки
            move!(r, next_side)
            count_steps += 1
        else
            break  #например робот у верхней границы там нет конца у перегородки
        end # он будет идти влево пока там нет перегородки и упрется в угол
    end #выхолом из цикла станет break когда if isborder(r, next_side) станет true,то есть будет перегородка всегда сверху и появится слева, а это значит, что угол
    # перегородки не пересекаются -> между границами и любой внутри есть расстояние 
    #Между двумя перегородками всегда есть расстояние и поэтому условие об окончании перегородки в данном направлении выполнится раньше,чем проверка на ортогональную сторону
    if isborder(r,side) == false
        move!(r,side)    
        while isborder(r,inv_next_side) == true
            move!(r,side)
        end   
        result = true #не у внешней рамки обошли с нужной стороны перегородку и стоим рядом с ней
        
        for _ in 1:count_steps   #count_steps=0 если не делается шагов в сторону next_side
            move!(r,inv_next_side)
        end
    
    else
        result = false #достиг внешней перегородки
    end
    
    return result
    
end

function move_by_marker!(r::Robot,side::HorizonSide, num_steps::Int)
    for _ in 1:num_steps
      detour!(r,side)     #возврат назад 
    end  #если нет перегородки то выполнится только условие ее отстутсвия и продвинется на одну клетку
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))  



