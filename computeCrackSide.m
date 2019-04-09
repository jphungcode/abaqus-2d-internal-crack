function centroid = computeCentroid(nodelist, elementlist,crackeleset )
%determine which crack side the element lies on
%   Does this by calculating the element centriod and determine whether it
%   lies above or below the crack line equation.
%   nodelist = entire node list from input file
%  elementlist = entire element list from input file
% crackeleset = elements belonging to the crack face
for i = 1:length(crackeleset)
   element_loc = elementlist(crackeleset(i,1),:); 
end

for i=1:size(element_loc,1)
   for k=2:size(element_loc,2)
       x(1,k-1) = nodelist(element_loc(i,k),2);
       y(1,k-1) = nodelist(element_loc(i,k),3);
   end
   [geom, ineer,cpmo] = polygeom(x,y);
   x_cen = geom(2);
   y_cen = geom(3);
   centroid(i,1) = element_loc(i,1);
   centroid(i,2) = x_cen;
   centroid(i,3) = y_cen;
end


end

