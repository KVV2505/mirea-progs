#Подсчитать число и прямоугольных и прямолинейных 
#(вертикальных и горизонтальных) перегородок
global count=0

function count_partition!(r::Robot)
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        movements!(r,West)
        movements!(r,Sud)
    end
    score=0
    count_b=0
    side=Ost
    while (isborder(r,Ost)==false)
        if (isborder(r,Nord)==true)
            move!(r,inverse(side))
            if (isborder(r,Nord)==false)
                count_b=count_b+1
            end
            move!(r,side)
            
            end
            move!(r,side)
    end
    
    if isborder(r,Nord)==false
        move!(r,Nord)
    end  
    
    side=West
    while ((isborder(r,Nord)==false) || ((isborder(r,West)==false) && (isborder(r,Ost)==false)))
        score=score+find_partition!(r,side)
        if (isborder(r,Nord)==false)
            move!(r,Nord)
        end
        side=inverse(side)
    end

return score+count_b
end

function find_partition!(r::Robot,side::HorizonSide)
    gor=0
    vert=0
    while (check!(r,side)==true)
        if (isborder(r,Nord)==true)
            move!(r,inverse(side))
            if (isborder(r,Nord)==false)
                gor=gor+1
            end
            move!(r,side)
        end
        vert=vert+count
       
    end
return gor+vert
end

function check!(r::Robot,side::HorizonSide)
    global count
    next_side=next(side) #сторона, перпендикулярная исходной (для севера-запад и тд)
    inv_next_side=inverse(next_side) #для возврата (для севера это будет восток)
    steps=0
    count_steps=0
    count=0
   
    if ((isborder(r,Sud)==false) && (isborder(r,side)==true))
        move!(r,Sud)
        if isborder(r,side)==false
            move!(r,side)
            if (isborder(r,Nord)==false)
                count=1
               
            else
                count=0
            end
            move!(r,inverse(side))
        else
            count=0  
        end     
        move!(r,Nord) 
    end
    
    while (isborder(r,side)==true) 
        if isborder(r, next_side) == false #или угол или конец перегородки
            move!(r, next_side)
            count_steps += 1
        else
            break  
        end 
    end 
    
    if isborder(r,side) == false
        move!(r,side)    
        while (isborder(r,inv_next_side) == true) && (count_steps!=0) #сравнение с нулем для определения, был ли обход
            move!(r,side)
        end   
        result = true #не у внешней рамки обошли с нужной стороны перегородку и стоим рядом с ней
        
        for _ in 1:count_steps   #count_steps=0 если не делается шагов в сторону next_side
            move!(r,inv_next_side)
        end
        
    else
        result = false #достиг внешней перегородки
        for _ in 1:count_steps   #count_steps=0 если не делается шагов в сторону next_side
            move!(r,inv_next_side)
        end
 end
    return result
end

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4)) 
        
            
          






