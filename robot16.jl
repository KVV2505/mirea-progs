#Задача 16 аналогична задаче 3, но дополнительно на поле могут находиться
#внутрение перегородки прямоугольной формы, среди которых могут быть и вырожденые 
#прямоугольники (отрезки), эти внутренние перегородки изолированы друг от друга и от 
#внешней рамки.

#ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
#РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы

function mark_pole!(r::Robot)
    count_steps=[]
    
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))
        push!(count_steps,moves!(r,Sud))
    end

    side=Ost
    
    while isborder(r,side)==false   # в самом низу только одна граница-поле иначе будет смежная с ним
        putmarker!(r)
        move!(r,side) #проход по нижней границе
    end

    if isborder(r,Nord)==false
        putmarker!(r)
        move!(r,Nord)
        side=inverse(side)
    end
     
    while  ((isborder(r,Nord)==false) || ((isborder(r,Ost)==false) &&  (isborder(r,West)==false)))
        putmarkers!(r, side) 
       if (side==West)
           while ismarker(r)==true 
               move!(r,Nord)
            end
        elseif (side==Ost)
            while ismarker(r)==false
                move!(r,Sud)
            end
            move!(r,Nord)
        end

        side=inverse(side)   
   end
     
      
   while isborder(r,side)==false 
        putmarker!(r)
        move!(r,side) 
    end
    putmarker!(r)

    if isborder(r,West)==true  #возврат в угол
        while isborder(r,Sud)==false
            move!(r,Sud)
        end
   elseif isborder(r,Ost)==true
       while isborder(r,Sud)==false
           move!(r,Sud)
       end
        while isborder(r,West)==false
            move!(r,West)
        end
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
    putmarker!(r)       
    while (detour!(r,side)==true)
        if ismarker(r)==false
            putmarker!(r)
        end
    end      
end


function detour!(r::Robot,side::HorizonSide)::Bool
    next_side=next(side) #сторона, перпендикулярная исходной (для севера-запад и тд)
    inv_next_side=inverse(next_side) #для возврата (для севера это будет восток)
    steps=0
        while (isborder(r,side)==true)  
            if isborder(r, next_side) == false #или угол или конец перегородки
                move!(r, next_side)
                steps += 1
            else
                break  #например робот у верхней границы там нет конца у перегородки
            end # он будет идти влево пока там нет перегородки и упрется в угол
        end #выхолом из цикла станет break когда if isborder(r, next_side) станет true,то есть будет перегородка всегда сверху и появится слева, а это значит, что угол
        # перегородки не пересекаются -> между границами и любой внутри есть расстояние 
        #Между двумя перегородками всегда есть расстояние и поэтому условие об окончании перегородки в данном направлении выполнится раньше,чем проверка на ортогональную сторону
        if isborder(r,side) == false
            move!(r,side)    
            while (isborder(r,inv_next_side) == true) 
                if ismarker(r)==false
                    putmarker!(r)
                end
                move!(r,side)
            end   
            result = true #не у внешней рамки обошли с нужной стороны перегородку и стоим рядом с ней
            
            for _ in 1:steps   #count_steps=0 если не делается шагов в сторону next_side
                move!(r,inv_next_side)
            end
        
        else
            result = false #достиг внешней перегородки
        end
        
        return result
        
end
    

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))  