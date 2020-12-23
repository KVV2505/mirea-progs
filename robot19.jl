"Эта задача аналогична задаче 9, но дополнительно на неограниченном 
поле могут находиться изолированные прямолинейные перегородки, в том числе и 
неограниченно продолжающиеся в одну из своих сторон"

function find_marker!(r::Robot)
    num_step=1
    side=Nord
    while  ismarker(r)==false
        for _ in 1:2   #для двух сторон
            marker_is_find!(r,side,num_step)
            side=next(side)    #после второго выполения функции будет взята третья сторона, исходная для след цикла
        end
        num_step=num_step+1
    end
end

function marker_is_find!(r::Robot,side::HorizonSide,num_step::Int)  
    x_start=0
    for _ in 1:num_step   
        x_end=0
        steps=0
        if isborder(r,side)==false       
            if (ismarker(r)==false)
                move!(r,side) 
            else
                break
            end
        else
            side_ort=next(side)
            while isborder(r,side)==true
                inv_side=inverse(side_ort) 
                steps=steps+1  
                moves!(r,side_ort,steps)  
                x_end=x_end+steps
                if isborder(r,side)==true
                    steps=steps+1
                    moves!(r,inv_side,steps) 
                    x_end=x_end-steps
            
                else
                    break
                end
            end
            move!(r,side)
            dist=abs(x_end-x_start)
            if (x_end<0)
                if (side==West)
                    for _ in 1:dist
                        move!(r,Sud)
                    end
                elseif (side==Nord)
                    for _ in 1:dist
                        move!(r,West)
                    end
                elseif (side==Ost)
                    for _ in 1:dist
                        move!(r,Nord)
                    end
                elseif (side==Sud)
                    for _ in 1:dist
                       move!(r,Ost)
                    end
                end
            elseif (x_end>0)
                if (side==West)
                    for _ in 1:dist
                        move!(r,Nord)
                    end
                elseif (side==Nord)
                    for _ in 1:dist
                        move!(r,Ost)
                    end
                elseif (side==Ost)
                    for _ in 1:dist
                       move!(r,Sud)
                    end
                elseif (side==Sud)
                    for _ in 1:dist
                        move!(r,West)
                    end
                end
            end
        
        end
        
    end
end

function moves!(r::Robot,side::HorizonSide,steps::Int)    
    for _ in 1:steps
        move!(r,side)
    end  
end 
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))  
next(side::HorizonSide)=HorizonSide(mod(Int(side)+1,4))  


