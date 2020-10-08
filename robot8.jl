#ДАНО: Робот - рядом с горизонтальной перегородкой (под ней), бесконечно продолжающейся в обе стороны, в которой имеется проход шириной в одну клетку.
#РЕЗУЛЬТАТ: Робот - в клетке под проходом
function find_passage!(r)
    side=West
    while isborder(r,Nord)==true
        putmarker!(r)
        side=inverse(side)  
        move_by_markers!(r,side)    
    end
end

function move_by_markers!(r::Robot,side::HorizonSide)    
    while ismarker(r)==true
        move!(r,side)
    end  
end  

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  

     