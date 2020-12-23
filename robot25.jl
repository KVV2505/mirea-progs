#Найти прямоугольную перегородку, включая внешнюю рамку, с наибольшей средней температурой клеток периметра

#Найти перегородку-найти координаты нижнего угла,то есть нижнего юго-западного угла,клетку внутри пергородки
#будет найдена клетка внутри перегородки, клетка-юго-западный угол 
#начало отсчета координат идет с 0,0 

include("robolib.jl")
global count_x=0 #когда робот обходит перегородку, то его координата х меняется,это необходимо учитывать
#кол-во шагов при обходе по горизонтали необходимо добавить к начальной координатеы
function max_temp!(r::Robot)
max_x=0
max_y=0
    while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
        movements!(r,West)
        movements!(r,Sud)
    end    
summ=0
count=0 
    for side in(Ost,Nord,West,Sud)
        while isborder(r,side)==false
            move!(r,side)
            summ=summ+temperature(r)
            count=count+1
        end
    end
max=summ/count
side=Ost
summ=0
count=0
x=0
y=0
mid_x=0
while (isborder(r,Ost)==false)
    if (isborder(r,Nord)==true)
        for side in(Nord,West,Sud,Ost)
            while isborder(r,side)==true
                move!(r,inverse(next(side)))
                summ=summ+temperature(r)
                count=count+1
            end
            move!(r,side)
            mid_x=x
        end
        while isborder(r,Nord)==true
            move!(r,side)
            x=x+1
        end
    else
        move!(r,Ost)
        x=x+1
    end
mid=summ/count
if mid>max
    max=mid
    max_x=mid_x
    max_y=1
end 
end
if isborder(r,Nord)==false
    move!(r,Nord)
    y=y+1
end      
now_x=x
side=West
while ((isborder(r,Nord)==false) || ((isborder(r,West)==false) && (isborder(r,Ost)==false)))
    t,x,now_x=temperature!(r,side,now_x) 
    if t>max
        max=t
        max_x=x
        max_y=y+1
    end
    if (isborder(r,Nord)==false)
        move!(r,Nord)
        y=y+1
    end
    side=inverse(side) 
end      
return max_x,max_y
end

function temperature!(r::Robot,side::HorizonSide,x::Int)
    c=0
    s=0
    max=0
    coord=x
    mid=0
    max_coord=0
    mid_coord=0
    while (detour!(r,side)==true)
            if (count_x!=0)
                if side==Ost
                    coord=coord+count_x+1
                else
                    coord=coord-count_x-1
                end
            else
                if side==Ost
                    coord=coord+1
                else
                    coord=coord-1
            
                end
            end
        if isborder(r,Nord)==true
             if side==West
                while isborder(r,Nord)==true
                    move!(r,West)
                    coord=coord-1
                end   
               move!(r,Ost)
               coord=coord+1
               
            end
           mid_coord=coord
            for side in(Nord,West,Sud,Ost)
                while isborder(r,side)==true
                    move!(r,inverse(next(side)))
                    s=s+temperature(r)
                    c=c+1
                end
                move!(r,side)
            end

            if side==West
                move!(r,West)
                coord=coord-1
            end
            
            while isborder(r,Nord)==true
                if side==Ost
                    move!(r,Ost)
                    coord=coord+1
                 end
            end
          
        mid=s/c
        end
        if mid>max
            max=mid
            max_coord=mid_coord
        end
    end
return max,max_coord,coord
end

function detour!(r::Robot,side::HorizonSide)::Bool
    global count_x=0
    next_side=next(side) 
    inv_next_side=inverse(next_side)  
    steps=0
    while (isborder(r,side)==true)  
            if isborder(r, next_side) == false 
                move!(r, next_side)
                steps += 1
             else
                break  
            end 
    end
        if isborder(r,side) == false
            move!(r,side)    
            while ((isborder(r,inv_next_side) == true) && (steps!=0))
                count_x=count_x+1 #кол-во шагов по горизонтали при обходе перегородки
                move!(r,side) 
            end   
            result = true 
            for _ in 1:steps  
                move!(r,inv_next_side)
            end
        else
            result = false 
            for _ in 1:steps  
                 move!(r,inv_next_side)
             end
         end 
return result
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))














