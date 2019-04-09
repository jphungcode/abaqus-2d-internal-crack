function cs1_face = sortFaces(crackside1)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
cs1_face1 = [];
cs1_face2 = [];
cs1_face3 = [];
cs1_face4 = [];
for i=1:length(crackside1)
   if crackside1(i,2) == 1 %face 1
       cs1_face1 = [cs1_face1; crackside1(i,:)];
   elseif crackside1(i,2) == 2
       cs1_face2 = [cs1_face2; crackside1(i,:)];
   elseif crackside1(i,2) == 3
       cs1_face3 = [cs1_face3; crackside1(i,:)];
   elseif crackside1(i,2) == 4
       cs1_face4 = [cs1_face4; crackside1(i,:)];
   else
       continue;
   end
end

cs1_face = {cs1_face1;cs1_face2;cs1_face3;cs1_face4};
end

