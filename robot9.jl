#ДАНО: Где-то на неограниченном со всех сторон поле и без внутренних 
#перегородок имеется единственный маркер. Робот - в произвольной клетке поля.
#РЕЗУЛЬТАТ: Робот - в клетке с тем маркером.
function find_marker!(r)
    num_step=1
    side=Nord
    while  ismarker(r)==false
        for _ in 1:2   #для двух сторон
            marker_is_find!(r,side,num_step)
            side=next(side)    #после второго выполения функции будет взята третья сторона, исходная для след цикла
        end
        num_step=num_step+1
    end
end

function marker_is_find!(r::Robot,side::HorizonSide,num_step::Int)  
        for _ in 1:num_step   
            move!(r,side)
        end

    
end
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))  

