#ДАНО: Робот - в произвольной клетке ограниченного 
#прямоугольной рамкой поля без внутренних перегородок и 
#маркеров.
#РЕЗУЛЬТАТ: Робот - в исходном положении в центре косого 
#креста (в форме X) из маркеров.
#(Подсказка: решение будет подобно решению задачи 1, если 
#направление премещения Робота задавать кортежами пары 
#значений типа HorizonSide)

function mark_cross!(r::Robot) 
    for side in ((Nord,Ost),(Sud,Ost),(Sud,West),(Nord,West))
        putmarkers!(r,side)
        move_by_marker!(r,inverse(side))
    end
    putmarker!(r)
end 

function putmarkers!(r::Robot,side::NTuple{2,HorizonSide})
    while ((isborder(r,side[1])==false) && (isborder(r,side[2])==false))
           move!(r,side)
           putmarker!(r)
    end   
end

function HorizonSideRobots.move!(r::Robot, side::NTuple{2,HorizonSide})
    for s in side  #серия шагов в заданной последовательности направлений
        move!(r,s) # шаг на север, шаг восток при каждом выхове
    end   
end

function move_by_marker!(r::Robot,side::NTuple{2,HorizonSide})
    while ismarker(r)==true
         move!(r,side)
    end
end

inverse(side::NTuple{2,HorizonSide}) = (inverse(side[1]),inverse(side[2]))
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))