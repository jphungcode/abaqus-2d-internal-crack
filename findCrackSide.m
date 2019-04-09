function [crackside1, crackside2,slope] = findCrackSide(X,Y, centroid)
%	X and Y are the node coordinates for the crack line
%   centroid is in the format [elementID, x_cen, y_cen]
crackside1 = [];
crackside2 = [];
face1 = [];
face2 = [];
x_cen = centroid(:,2);
y_cen = centroid(:,3);
% check if vertical line, else use polyfit
isvertical = ismembertol(X,mean(X),0.001);
ishorz = ismembertol(Y,mean(Y),0.001);
if all(isvertical) ==1 
    slope = isvertical;
    for i=1:length(centroid)
       if x_cen(i) < mean(X)
           crackside1 = [crackside1; centroid(i,1)];
           face1 = [face1; centroid(i,4)];
       else
           crackside2 = [crackside2; centroid(i,1)];
           face2 = [face2; centroid(i,4)];
       end
    end
elseif all(ishorz) == 1
    slope = ishorz;
    for i=1:length(centroid)
        if y_cen(i) > mean(Y)
           crackside1 = [crackside1; centroid(i,1)];
           face1 = [face1; centroid(i,4)];
        else
           crackside2 = [crackside2; centroid(i,1)];
           face2 =[face2; centroid(i,4)];
        end
    end
else
    p = polyfit(X,Y,1);
    m = p(1);
    b = p(2);
    slope = [m,b];
    for i=1:length(centroid)
       if y_cen(i)-m*x_cen(i)-b > 0
          crackside1 = [crackside1; centroid(i,1)];
          face1 = [face1; centroid(i,4)];
       else
          crackside2 = [crackside2; centroid(i,1)];
          face2 =[face2; centroid(i,4)];
       end
    end
end
crackside1 = [crackside1, face1];
crackside2 = [crackside2, face2];
end

