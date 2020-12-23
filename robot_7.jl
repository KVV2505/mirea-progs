#ДАНО: Робот - в произвольной клетке ограниченного прямоугольного 
#поля (без внутренних перегородок)

#РЕЗУЛЬТАТ: Робот - в исходном положении, в клетке с роботом 
#стоит маркер, и все остальные клетки поля промаркированы в шахматном
#порядке

global FLAG_MARK = nothing

function mark_chess!(r::Robot)
    global FLAG_MARK 
    putmarker!(r)
    num_gor=moves!(r,West)
    num_vert=moves!(r,Sud)

    summ_coordinat=num_vert+num_gor   #Четная сумма всегда одного цвета, нечетная другого
    if isodd(summ_coordinat)==true
        FLAG_MARK = false
    else
        FLAG_MARK = true
    end    

    side=Ost
    
    while isborder(r,Nord)==false
        putmarkers!(r,side)
        FLAG_MARK=!FLAG_MARK
        move!(r,Nord)
        side=inverse(side)
    end
    putmarkers!(r,side)
    
    while isborder(r,West)==false
        move!(r,West)
    end
    
    while isborder(r,Sud)==false
         move!(r,Sud)
    end    
    return!(r,Ost,num_gor)
    return!(r,Nord,num_vert)
end

function putmarkers!(r::Robot,side::HorizonSide)
    global FLAG_MARK
    while isborder(r,side)==false
        if FLAG_MARK==true
            putmarker!(r)
        end
        move!(r,side)
        FLAG_MARK=!FLAG_MARK
    end
    if FLAG_MARK==true
        putmarker!(r)
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
 
function return!(r::Robot,side::HorizonSide,steps::Int)
    for _ in 1:steps
        move!(r,side)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  
    








