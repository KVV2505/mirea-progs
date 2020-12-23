#ДАНО: Робот - в произвольной клетке поля (без внутренних перегородок и маркеров)
#РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки по периметру внешней рамки промакированы
function mark_frame_perimetr!(r::Robot)
    steps_gor=moves!(r,West)
    steps_vert=moves!(r,Sud)
    side=Ost
    for _ in 1:4
        putmarkers!(r,side)
        side=next(side)
    end
    
    moves!(r, Nord, steps_vert)
    moves!(r, Ost, steps_gor)
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
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end

next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))
    