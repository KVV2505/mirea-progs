#Посчитать число всех горизонтальных прямолинейных перегородок (вертикальных - нет)

function count_partition!(r::Robot)
    while (isborder(r,West)==false)
        move!(r,West)
    end
    
    while (isborder(r,Sud)==false)
        move!(r,Sud)
    end
    count=0
    side=Ost
    while ((isborder(r,Nord)==false) || ((isborder(r,West)==false) && (isborder(r,Ost)==false)))
        count=count+find_partition!(r,side)
        if (isborder(r,Nord)==false)
            move!(r,Nord)
        end
        side=inverse(side)
    end
return count
end

function find_partition!(r::Robot,side::HorizonSide)
    count_bord=0
    while (isborder(r,side)==false)
        if (isborder(r,Nord)==true)
            move!(r,inverse(side))
            if (isborder(r,Nord)==false)
                count_bord=count_bord+1
            end
            move!(r,side)
        end
        move!(r,side)
    end
return count_bord
end

inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  