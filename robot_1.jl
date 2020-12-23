#ДАНО: Робот находится в произвольной клетке ограниченного прямоугольного поля без внутренних перегородок и маркеров.
#РЕЗУЛЬТАТ: Робот — в исходном положении в центре прямого креста из маркеров, расставленных вплоть до внешней рамки.

#Рассмотреть отдельно еще случай, когда изначально в некоторых клетках поля могут находиться маркеры.
function mark_cross!(r::Robot)
    for side in(Nord,West,Sud,Ost)
        putmarkers!(r,side)
        side_inv=inverse(side)
        move_by_marker!(r,side_inv)
    end
putmarker!(r)
end

function putmarkers!(r::Robot,side::HorizonSide)
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end

function move_by_marker!(r::Robot,side::HorizonSide)
    while ismarker(r)==true
        move!(r,side)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))