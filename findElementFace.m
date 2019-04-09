function ele_index = findElementFace(ele_index, node_loc)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

face = zeros(length(ele_index),2);
for k=1:length(ele_index)
    t=1;
   for j = 1:size(ele_index,2)-1
       for i = 1:length(node_loc)
            if node_loc(i,1) == ele_index(k,j+1)
                face(k,t) = j;
                t=t+1;
            end
       end
   end
end

ele_face = zeros(length(face),1);

for i=1:length(face)
   if face(i,1) == 1 && face(i,2) == 4
      ele_face(i,1) = 4;
   elseif face(i,1) == 1 && face(i,2) == 2
       ele_face(i,1) = 1;
   elseif face(i,1) == 2 && face(i,2) == 3
       ele_face(i,1) = 2;
   elseif face(i,1) == 3 && face(i,2) == 4
       ele_face(i,1) = 3;
   elseif face(i,1) == 1 && face(i,2) == 3
       ele_face(i,1) = 3;
   end  
end

ele_index = [ele_index, ele_face];

end

