#ДАНО: Робот - в произвольной клетке ограниченного прямоугольного поля, 
#на котором могут находиться также внутренние прямоугольные перегородки 
#(все перегородки изолированы друг от друга, прямоугольники могут вырождаться 
#в отрезки)
#РЕЗУЛЬТАТ: Робот - в исходном положении, и в 4-х приграничных клетках, две из 
#которых имеют ту же широту, а две - ту же долготу, что и Робот, стоят маркеры.
count_steps=[]
function put_markers!(r::Robot)
    #putmarker!(r)
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        push!(count_steps,moves!(r,West))#если равно нулю,то все равно добавляется в массив в этом порядке
        push!(count_steps,moves!(r,Sud))
    end
    count1=0
    count2=0
    side1=Nord
    side2=Ost

    for (i,n) in enumerate(count_steps)
        if isodd(i)==false
            count1=count1+n #кол-во шагов вниз
        else
           count2=count2+n    
        end
    end
    markers!(r,side1,side2,count1,count2)  
    
    while isborder(r,West)==false
        move!(r,West)
    end
    return_r!(r)
end

function markers!(r::Robot, side1::HorizonSide, side2::HorizonSide, steps1::Int, steps2::Int)
    county=0
    countx=0
    for _ in 1:steps1
        move!(r,side1)
    end
    putmarker!(r)
    while isborder(r,Nord)==false
        move!(r,Nord)
        county=county+1
    end
    for _ in 1:steps2
        move!(r,side2)
    end
    putmarker!(r)
    while isborder(r,Ost)==false
        move!(r,Ost)
        countx=countx+1
    end
    
    for _ in 1:county
        move!(r,Sud)
    end
    putmarker!(r)
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    for _ in 1:countx
        move!(r,West)
    end
    putmarker!(r)
end

function moves!(r::Robot,side::HorizonSide)
    num_steps=0
    while isborder(r,side)==false
        move!(r,side)
        num_steps=num_steps+1
    end
return num_steps
end

function return_r!(r::Robot)
    for (i,n) in enumerate(reverse!(count_steps))  
        if isodd(i)==true  
            side=Nord
        else
            side=Ost   
        end
        move_r!(r,side,n)
    end
end 

function move_r!(r::Robot,side::HorizonSide,steps::Int)
    for _ in 1:steps
        move!(r,side)
    end
end
