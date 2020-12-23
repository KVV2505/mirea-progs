#На прямоугольном поле произвольных размеров расставить маркеры в виде "шахматных" клеток, 
#начиная с юго-западного угла поля, когда каждая отдельная "шахматная" клетка имеет размер 
#n x n клеток поля (n - это параметр функции). Начальное положение Робота - произвольное, 
#конечное - совпадает с начальным. Клетки на севере и востоке могут получаться "обрезанными" - 
#зависит от соотношения размеров поля и "шахматных" клеток. (Подсказка: здесь могут быть 
#полезными две глобальных переменных, в которых будут содержаться текущие декартовы координаты
# Робота относительно начала координат в левом нижнем углу поля, например)

global x=0
global y=0
global FLAGx=false
global FLAGy=false
global count=0
global count_n=0
function mark_chess!(r::Robot,n::Int) #n-количество маркеров
    global y
    side=Ost
    num_gor=moves!(r,West)
    num_vert=moves!(r,Sud)
    while (isborder(r,Nord)==false || ((isborder(r,West)==false) && (isborder(r,Ost)==false)))
        putmarkers!(r,n,side)
        move!(r,Nord)
        y=y+1
        side=inverse(side)
        while isborder(r,side)==false
            move!(r,side)
        end
        side=Ost
    end
    putmarkers!(r,n,side)     
    
    while isborder(r,West)==false
        move!(r,West)
    end
   
    while isborder(r,Sud)==false
        move!(r,Sud)
    end
    
    return!(r,Ost,num_gor)
    return!(r,Nord,num_vert)
end

function moves!(r::Robot,side::HorizonSide)
    steps_count=0
    while isborder(r,side)==false
        move!(r,side)
        steps_count=steps_count+1
    end
return steps_count
end

function putmarkers!(r::Robot,n::Int,side::HorizonSide)
    global x
    global y
    global FLAGx
    global FLAGy
    global count
    global count_n
    
    if mod(y,n)==0   #если координата по у начело делится на n, то меняем флаг
        FLAGy=!FLAGy # самая начальная координата по у =0
    end # если n=2, то ставится на правду в 0, если 2, то на ложь
     # n=4, то опять на правду и тд для любого n
    if FLAGy==true 
        while (isborder(r,side)==false)
            put_marker!(r,side,n)
            if (isborder(r,side)==false)
                move!(r,side)
            end    
            not_put_marker!(r,side,n)
        end 
        
    else
        while (isborder(r,side)==false)
             not_put_marker!(r,side,n)
             if (isborder(r,side)==false) 
                put_marker!(r,side,n)
            end 
        end
    end
end

function put_marker!(r::Robot,side::HorizonSide,n::Int)
    count=1
    putmarker!(r)
    while ((isborder(r,side)==false) && (count<n))
            count=count+1
            move!(r,side)
            putmarker!(r)
    end
if ((isborder(r,side)==false) && (FLAGy==false))
    move!(r,side)   
end 
end  
 

function not_put_marker!(r::Robot,side::HorizonSide,n::Int)
    count_n=0
    while ((isborder(r,side)==false) && (count_n<n))
        count_n=count_n+1
        move!(r,side)
    end
end

function return!(r::Robot,side::HorizonSide,steps::Int)
    for _ in 1:steps
        move!(r,side)
    end
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  