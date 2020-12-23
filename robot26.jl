#Расставить маркеры в "полосочку" (через n пустых "полосок"). 
#Причем "полосочки" могут быть, в одном случае, "прямыми", а в 
#другом - косыми.

#Требуется написать обобщенную функцию , которая 
#бы могла расставлять маркеры как по "прямым" (горизонтальным или 
#вертикальнымм), так и по наклонным линиям (наклоны могут быть или
#в одну сторону или в другую).

function mark_zebra!(r::Robot, direction, ort_direction, distance_stripes::Int, shift_first::Int)
    #side-фактический параметр, мб разных типов
    #direction-направление, по которому ставятся полосочки
    #ort_direction-направление, перпендикулярное расстановке
    #distance_stripes-расстояние между полосочками
    #shift_first-отступ первой полосочки от поля
    #параметры, указываемые при вызове подпрограммы,называются – фактическими.
    start_position = start_angle!(direction,ort_direction) 
    #стартовое положение
    
    move_to_corner!(r,start_position)
    #перемещение в стартовый угол
    
    shift!(r,inverse(ort_direction), shift_first) 
    #перемещние от границы до первой полосочки

    put_mark!(r,inverse(direction))
    #первая полосочка промаркирована

    count=0
    while ((ismarker(r)==true) && (isborder(r,direction)==false))
        move!(r,direction)
    end
    if isborder(r,inverse(direction))==false
        move!(r,inverse(direction))
    end
    while isborder(r,direction)==false
        move!(r,direction)
        count=count+1
    end             

    if (count==0)
        while isborder(r,direction)==false
            move!(r,direction)
        end
    else
        if ismarker(r)==false
            putmarker!(r)
        end
        for _ in 1:count
           move!(r,inverse(direction))
           if ismarker(r)==false
            putmarker!(r)
        end
        end
    end
    
    direction=inverse(direction)
    
    while distance!(r,inverse(ort_direction), distance_stripes) == true
        count=0
        direction = inverse(direction)
        put_mark!(r,line_side)
        while ((ismarker(r)==true) && (isborder(r,inverse(direction))==false))
            move!(r,inverse(direction))
        end
        if isborder(r,direction)==false
            move!(r,direction)
        end
        while isborder(r,inverse(direction))==false
            move!(r,inverse(direction))
            count=count+1
        end             

        if (count==0)
            while isborder(r,direction)==false
                move!(r,direction)
            end
        else
            putmarker!(r)
            for _ in 1:count
               move!(r,direction)
               putmarker!(r)
            end
        end
        
    end 

end

function move_to_corner!(r::Robot, side)
    for i in 1:2
    while isborder(r,side[i])==false 
        move!(r,side[i])   
    end
end
  
end

function shift!(r::Robot, side,count_steps::Int)    
    for _ in 1:count_steps    
        if isborder(r,side)==false
            move!(r,side)
        end  
    end
end

function distance!(r::Robot, side, steps::Int)::Bool
   result=false
 for _ in 1:steps     
        if isborder(r,side)==false
            move!(r,side)
           result=true
        else
            result=false 
        end
    end
return result
end

function put_mark!(r::Robot,side)
   putmarker!(r) 
   putmarkers!(r,side)
    
end

function putmarkers!(r::Robot,side) 
    while isborder(r,side)==false
        move!(r,side)
        putmarker!(r)
    end
end


start_angle!(direction::NTuple{2,HorizonSide},ort_direction::NTuple{2,HorizonSide}) = ort_direction
start_angle!(direction::HorizonSide,ort_direction::HorizonSide) = (direction,ort_direction)

inverse(side::NTuple{2,HorizonSide}) = (inverse(side[1]),inverse(side[2]))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))

HorizonSideRobots.isborder(r::Robot,side::NTuple{2,HorizonSide}) = (isborder(r,side[1]) || isborder(r,side[2]))

HorizonSideRobots.move!(r::Robot,side::NTuple{2,HorizonSide}) = for s in side move!(r,s) end

#функции называются так,иначе стандартные функции из модуля
#HorizonSideRobots перекрываются (доступ к ним) после переопределения 
#этих функций в другом пространстве имен