#ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок.
#РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.
#Рассмотреть отдельно еще случай, когда изначально в некоторых клетках поля могут находиться маркеры.

function mark_cross!(r::Robot)
    for side in(Nord,West,Sud,Ost)
        steps=moves!(r,side)
        side_inv=inverse(side)
        putmarkers!(r,side_inv,steps)
    end
putmarker!(r)
end

function moves!(r::Robot,side::HorizonSide)
    steps=0
    while isborder(r,side)==false
        move!(r,side)
        steps=steps+1
    end
return steps
end


function putmarkers!(r::Robot,side::HorizonSide,count_steps::Int)
    for _ in 1:count_steps
        if ismarker(r)==false
            putmarker!(r)
        end
        move!(r,side)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))