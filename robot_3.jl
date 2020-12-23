#ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля
#РЕЗУЛЬТАТ: Робот - в исходном положении, и все клетки поля промакированы
function mark_pole!(r::Robot)
    steps_vert=moves!(r,Sud)
    steps_gor=moves!(r,West)
    
    side=Ost
    
    while  ((isborder(r,Nord)==false) || ((isborder(r,Ost)==false) &&  (isborder(r,West)==false)))
        putmarkers!(r, side) 
        move!(r,Nord)
        if isborder(r,Ost)==true
             side=West
        elseif isborder(r,West)==true
            side=Ost
        end
    end
     
    if isborder(r,Ost)==true
        putmarkers!(r,West)   
        while isborder(r,Sud)==false
            move!(r,Sud)
        end
    elseif isborder(r,West)==true
        putmarkers!(r,Ost)
        while isborder(r,Sud)==false
            move!(r,Sud)
        end
        while isborder(r,West)==false
            move!(r,West)
        end
    end
    moves!(r,Nord,steps_vert)
    moves!(r,Ost,steps_gor) 
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
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end               
end
                     