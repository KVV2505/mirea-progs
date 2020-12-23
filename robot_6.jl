#ДАНО: На ограниченном внешней прямоугольной рамкой поле имеется ровно
# одна внутренняя перегородка в форме прямоугольника. 
#Робот - в произвольной клетке поля между внешней и внутренней
# перегородками. РЕЗУЛЬТАТ: Робот - в исходном положении и по всему 
# периметру внутренней перегородки поставлены маркеры.

function mark_rectangle!(r::Robot)
    count_steps=[]
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))
        push!(count_steps,moves!(r,Sud))
    end

    side=Ost
    count=0
    find_rectangle!(r,side)  #для первой строки 
    while isborder(r,Nord)==false 
        move!(r,Nord)
        side=inverse(side)
        find_rectangle!(r,side)
    end
    while ((isborder(r,Nord)==true) && (isborder(r,side)==false))
        move!(r,side)
        count=count+1
    end
    if (isborder(r,Nord)==false) 
        for _ in 1:count
            move!(r,inverse(side))
        end
        putmarkers!(r,side)
    end
    
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    while isborder(r,West)==false
        move!(r,West)
    end
    
    for (i,n) in enumerate(reverse!(count_steps))
        if isodd(i)==true   #нечетный    
            side=Nord  #Сначала запад, потом юг...массив перевенули, т. е сначала юг,потом запад
        else
           side=Ost
        end
        moves!(r,side,n) 
    end
end

function find_rectangle!(r::Robot,side::HorizonSide)
    while (isborder(r,Nord)==false) && (isborder(r,side)==false)    
        move!(r,side)                                               
    end
end

function putmarkers!(r::Robot,side::HorizonSide)
    side_vert=side
    putmarker!(r)
    while isborder(r,Nord)==true
        move!(r,side)
        putmarker!(r)
    end
    move!(r,Nord)
    putmarker!(r)
    while (isborder(r,West)==true) || (isborder(r,Ost)==true)
        move!(r,Nord)
        putmarker!(r)
    end
    side_vert=inverse(side_vert)
    move!(r,side_vert)
    putmarker!(r)
    while isborder(r,Sud)==true
        move!(r,side_vert)
        putmarker!(r)
    end
    move!(r,Sud)
    putmarker!(r)
    while (isborder(r,West)==true) || (isborder(r,Ost)==true)
        move!(r,Sud)
        putmarker!(r)
    end
end

function moves!(r::Robot,side::HorizonSide)
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps=num_steps+1
    end
return num_steps
end

function moves!(r::Robot,side::HorizonSide,count_steps::Int)
    for _ in 1: count_steps
        move!(r,side)
    end
end
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))