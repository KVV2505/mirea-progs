#Найти площадь наибольшей прямоугольной перегородки

include("robolib.jl")

function area!(r::Robot)
while ((isborder(r,West)==false) || (isborder(r,Sud)==false)) 
    movements!(r,West)
    movements!(r,Sud)
end 

side=Ost
s=0
a=0
b=0

while (isborder(r,Ost)==false)
    if isborder(r,Nord)==true
    while (isborder(r,Nord)==true)
        a=a+1
        move!(r,side)
    end
    move!(r,Nord)
  
    while (isborder(r,inverse(side))==true)
        b=b+1
        move!(r,Nord)
    end
    move!(r,Sud)    
    while isborder(r,inverse(side))==true
        move!(r,Sud)
    end
end
move!(r,Ost)
s=a*b
end

 if isborder(r,Nord)==false
    move!(r,Nord)
end      
s1=0
max=s
side=West
while ((isborder(r,Nord)==false) || ((isborder(r,West)==false) && (isborder(r,Ost)==false)))
    s1=find_area!(r,side) 
    if (isborder(r,Nord)==false)
        move!(r,Nord)
    end
    side=inverse(side)
    if s1>max
        max=s1
    end
end      
return max
end

function find_area!(r::Robot,side::HorizonSide)
    a=0
    b=0
    s=0
    max=0
    while (detour!(r,side)==true)
        if isborder(r,Nord)==true
                a=width!(r,side)
                b=height!(r,side)
                s=a*b
        end
        if s>max
            max=s
        end
    end
return max
end

function height!(r::Robot,side::HorizonSide)
    b=0
    while isborder(r,inverse(side))==true
        b=b+1
        move!(r,Nord)
    end
    move!(r,Sud)      
    while isborder(r,inverse(side))==true            
        move!(r,Sud)
    end

return b
end

function width!(r::Robot,side::HorizonSide)
    a=0
    while isborder(r,Nord)==true
        a=a+1
        move!(r,side)
    end
    move!(r,Nord)

return a
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))









