function return!(r::Robot,side::HorizonSide,steps::Int)
    for _ in 1:steps
        move!(r,side)
    end
end


function moves!(r::Robot,side::HorizonSide)
    steps_count=0
    while isborder(r,side)==false
        move!(r,side)
        steps_count=steps_count+1
    end
return steps_count
end

function movements!(r::Robot, side::HorizonSide) 
     while isborder(r,side)==false 
        move!(r,side) 
    end 
end

function detour!(r::Robot,side::HorizonSide)::Bool
       next_side=next(side) #сторона, перпендикулярная исходной (для севера-запад и тд)
       inv_next_side=inverse(next_side) #для возврата (для севера это будет восток)
       steps=0
       count_steps=0
       
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
               while ((isborder(r,inv_next_side) == true) && (steps!=0))
                   #count_steps=count_steps+1
                   move!(r,side)     
               end   
               result = true #не у внешней рамки обошли с нужной стороны перегородку и стоим рядом с ней
               
               for _ in 1:steps   #count_steps=0 если не делается шагов в сторону next_side
                   move!(r,inv_next_side)
               end
           
           else
               result = false #достиг внешней перегородки
               for _ in 1:steps   #count_steps=0 если не делается шагов в сторону next_side
                    move!(r,inv_next_side)
                end
            end
           
return result

end

