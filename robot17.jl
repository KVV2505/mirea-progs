"Задача  17 аналогична задаче 4, но дополнительно на поле могут 
находиться внутрение перегородки прямоугольной формы, среди которых могут
быть и вырожденые прямоугольники (отрезки), эти внутренние перегородки
изолированы друг от друга и от внешней рамки.

ДАНО: Робот - Робот - в произвольной клетке ограниченного прямоугольного поля

РЕЗУЛЬТАТ: Робот - в исходном положении, и клетки поля промакированы так:
 нижний ряд - полностью, следующий - весь, за исключением одной последней 
клетки на Востоке, следующий - за исключением двух последних клеток на 
Востоке, и т.д.

чтобы закрасить 12 клеток надо сделать 11 шагов, то есть,  количество шагов для каждой строки меньше клеток, 
которые необходимо закрасить,на единицу "


global flag=0

function mark_kross!(r::Robot)
    
    count_steps=[]
    
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))
        push!(count_steps,moves!(r,Sud))
    end

    side=Ost
    
    length_gor=0
    putmarker!(r)
    while isborder(r,Ost)==false
        move!(r,Ost) 
        putmarker!(r)
        length_gor=length_gor+1
        
    end
    
    while isborder(r,West)==false
        move!(r,West)
    end
    if (isborder(r,Nord)==false)  
        move!(r,Nord)
    end

    length_gor=length_gor-1

    while length_gor>0   
        putmarkers!(r,side,length_gor)
        if (side==West)
            while ismarker(r)==true 
                move!(r,Nord)
             end
         elseif (side==Ost)
             while ismarker(r)==false
                 move!(r,Sud)
             end
             if isborder(r,Nord)
                 move!(r,Nord)
             end
         end
        
        while (detour!(r,inverse(side))==true) end
        while (ismarker(r)==true) && (isborder(r,Nord)==false)
            move!(r,Nord)
        end 
        length_gor=length_gor-1
        side=Ost

    end
    
    while isborder(r,Sud)==false
        move!(r,Sud)    
    end   

for (i,n) in enumerate(reverse!(count_steps))  
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

function putmarkers!(r::Robot,side::HorizonSide,steps::Int)  
    a=steps
    putmarker!(r)
    while (detour!(r,side)==true)
        a=a-flag
        if (a>0) 
           putmarker!(r)   
       end
       a=a-1
    end
end

function detour!(r::Robot,side::HorizonSide)::Bool
 global flag
    next_side=next(side) #сторона, перпендикулярная исходной (для севера-запад и тд)
    inv_next_side=inverse(next_side) #для возврата (для севера это будет восток)
    steps=0
    count_steps=0
    check=false
    while (isborder(r,side)==true)  
            if isborder(r, next_side) == false #или угол или конец перегородки
                move!(r, next_side)
                steps += 1
                check=true #есть попытка обойти перегородку
            else
                break  #например робот у верхней границы там нет конца у перегородки
            end # он будет идти влево пока там нет перегородки и упрется в угол
        end #выхолом из цикла станет break когда if isborder(r, next_side) станет true,то есть будет перегородка всегда сверху и появится слева, а это значит, что угол
        # перегородки не пересекаются -> между границами и любой внутри есть расстояние 
        #Между двумя перегородками всегда есть расстояние и поэтому условие об окончании перегородки в данном направлении выполнится раньше,чем проверка на ортогональную сторону
        if isborder(r,side) == false
            move!(r,side)    
            while ((isborder(r,inv_next_side) == true) && (check==true))
                count_steps=count_steps+1
                move!(r,side)     
                
            end   
            result = true #не у внешней рамки обошли с нужной стороны перегородку и стоим рядом с ней
            
            for _ in 1:steps   #count_steps=0 если не делается шагов в сторону next_side
                move!(r,inv_next_side)
            end
        
        else
            result = false #достиг внешней перегородки
        end
        
        if (count_steps!=0)
            flag=count_steps
        else
            flag=0
        end
        
        return result
        
end


inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))
    
