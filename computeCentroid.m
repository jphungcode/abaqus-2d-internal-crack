function centroid = computeCentroid(nodelist,ele_face )
%determine which crack side the element lies on
%   Does this by calculating the element centriod and determine whether it
%   lies above or below the crack line equation.
%   nodelist = entire node list from input file
%  elementlist = entire element list from input file
% crackeleset = elements belonging to the crack face
for i=1:size(ele_face,1)
   if ele_face(i,5) ~= 0 %checking if quad element
      if ele_face(i,6) == 1
          x_cen = nodelist(ele_face(i,4),2);
          y_cen = nodelist(ele_face(i,4),3);
      elseif ele_face(i,6) == 2
          x_cen = nodelist(ele_face(i,5),2);
          y_cen = nodelist(ele_face(i,5),3);
      elseif ele_face(i,6) ==3
          x_cen = nodelist(ele_face(i,2),2);
          y_cen = nodelist(ele_face(i,2),3);
      else
          x_cen = nodelist(ele_face(i,3),2);
          y_cen = nodelist(ele_face(i,3),3);
      end
   else  %checking triangle element
        if ele_face(i,6) == 1
            x_cen = nodelist(ele_face(i,4),2);
            y_cen = nodelist(ele_face(i,4),3);
        elseif ele_face(i,6) == 2
            x_cen = nodelist(ele_face(i,2),2);
            y_cen = nodelist(ele_face(i,2),3);
        else
            x_cen = nodelist(ele_face(i,3),2);
            y_cen = nodelist(ele_face(i,3),3);
        end 
   end
%    for k=2:size(ele_face,2)-1
%        
%        if ele_face(i,k) == 0 
%             continue;
%        end
%        x(1,k-1) = nodelist(ele_face(i,k),2);
%        y(1,k-1) = nodelist(ele_face(i,k),3);
%    end
%    [geom, iner,cpmo] = polygeom(x,y);
%    x_cen = geom(2);
%    y_cen = geom(3);
   centroid(i,1) = ele_face(i,1);
   centroid(i,2) = x_cen;
   centroid(i,3) = y_cen;
   centroid(i,4) = ele_face(i,6);
end

end

