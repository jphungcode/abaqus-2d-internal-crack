%% 
clear all, clc
cd('/data/jphung/Finite Element/mortar-prism-FE');
%% 
input_file = 'mortar-prism-default.inp';
output_file = 'mortar-prism-modified.inp';
fid = fopen(input_file,'r');
C = textscan(fid, '%s','Delimiter','');
fclose(fid);
C = C{:};
num_cracksets = 1;
crackset_prefix = 'crack';
node = '*Node';
element = '*Element';
instancename = 'mortar-crack-1';
nsetlist = {}; elsetlist = {}; nodelist = {}; elementlist = {};
for i=1:num_cracksets
    nset_name = sprintf('*Nset, nset=%s%d',crackset_prefix,i);
    elset_name = sprintf('*Elset, elset=%s%d',crackset_prefix,i);
    nsetlist{i,1} = findSet(C,nset_name);
    elsetlist{i,1} = findSet(C,elset_name);
end
nodelist = findSet(C,node);
elementlist = findSet(C,element);

%% Grab node locations for crackset from nodelist varaiable
node_loc = cell(num_cracksets,1);
for i =1:size(nsetlist,1)
    temp_node_loc = [];
    for k=1:length(nsetlist{i,1})
        temp_node_loc(k,:) = nodelist(nsetlist{i,1}(k,1),:);
    end
    node_loc{i,1} = temp_node_loc;
end
%% 
ele_index = cell(num_cracksets,1);
for i = 1:size(elsetlist,1)
    temp_ele_index = [];
   for j=1:length(elsetlist{i,1})
        val1 = elsetlist{i,1}(j,1);
        index_ele = find(val1 == elementlist(:,1));
        temp_ele_index(j,:) = elementlist(index_ele,:);
%        for k=1:length(elementlist)
%            if val1 == elementlist(k,1)
%               temp_ele_index(j,:) = elementlist(k,:);
%            end
%        end
   end
   ele_index{i,1} = temp_ele_index;
end

%% determine the face of the element lying on crack line
ele_face = cell(num_cracksets,1);
for k=1:size(ele_index,1)
    ele_face{k,1} = findElementFace(ele_index{k,1},node_loc{k,1});
end
%% remove face 0 elements from ele_face
% for k=1:size(ele_face,1)
%     new_data = [];
%     for j=1:size(ele_face{k,1},1)
%         if ele_face{k,1}(j,end) ~= 0
%             new_data = [new_data; ele_face{k,1}(j,:)];
%         end
%     end
%     ele_face{k,1} = new_data;
% end

%% find centroid of element and determine which side the element is
centroid = {};
for k=1:size(ele_face,1)
    centroid{k,1} = computeCentroid(nodelist, ele_face{k,1});
    X = node_loc{k,1}(:,2);
    Y = node_loc{k,1}(:,3);
    [tmp_crackside1, tmp_crackside2, slope] = findCrackSide(X,Y,centroid{k,1});
    crackslope{k,1} = slope;
    crackside1{k,1} = tmp_crackside1;
    crackside2{k,1} = tmp_crackside2;
end
%% generate internal surface text
for k=1:size(crackside1,1)
    cs1_face = sortFaces(crackside1{k,1});
    cs2_face = sortFaces(crackside2{k,1});
    cs_face{k,1} = [cs1_face, cs2_face];
end
%% 

for k=1:size(cs_face,1) 
    ele_name{k,1} = sprintf('cs%d-1_face1',k);
    ele_name{k,2} = sprintf('cs%d-1_face2',k);
    ele_name{k,3} = sprintf('cs%d-1_face3',k);
    ele_name{k,4} = sprintf('cs%d-1_face4',k);
    ele_name{k,5} = sprintf('cs%d-2_face1',k);
    ele_name{k,6} = sprintf('cs%d-2_face2',k);
    ele_name{k,7} = sprintf('cs%d-2_face3',k);
    ele_name{k,8} = sprintf('cs%d-2_face4',k);
end
%% 
elset_inp = {};
ele_temp = {};
for k=1:size(cs_face,1)
    for i=1:4
        ele_temp = sortCrackElem(cs_face{k,1}{i,1},ele_name{k,i},instancename);
        elset_inp = [elset_inp; ele_temp];
        ele_temp1 = sortCrackElem(cs_face{k,1}{i,2},ele_name{k,i+4},instancename);
        elset_inp = [elset_inp; ele_temp1];
    end
end
%% 
for k=1:size(ele_name,1)
    left_name{k,1} = ele_name(k,1:4);
    right_name{k,1} = ele_name(k,5:8);
end
%% 
%define crack surface
for k=1:size(left_name,1)
    left_surf{k,1} = defineSurf(elset_inp,left_name{k});
    right_surf{k,1} = defineSurf(elset_inp,right_name{k});
end
%% 
%concatenate headers with surf sets
surf_inp = {};
for k=1:size(left_surf,1)
    left_surf_head = sprintf('*Surface,Type=Element,name=left_surf-%d',k);
    right_surf_head = sprintf('*Surface,Type=Element,name=right_surf-%d',k);
    surf_inp = [surf_inp;left_surf_head;left_surf{k};right_surf_head;right_surf{k}];
end
crack_inp = [elset_inp;surf_inp];
%% generate surface contact conditions
friction = 0;
crack_clearance = 0;
surface_contact = {'** INTERACTION PROPERTIES';
                   '*Surface Interaction, name=IntProp-1';
                   '*Friction';
                   sprintf('%d',friction);
                   '*Surface Behavior, pressure-overclosure=HARD'};
interact_inp = {};
for k=1:num_cracksets
    interact_head = {
                    sprintf('**Interaction: INT-%d',k);
                    sprintf('*Clearance, cpset=INT-%d, value=%d',k,crack_clearance);
                    sprintf('*Contact Pair, interaction=INTPROP-1, mechanical constraint=KINEMATIC, small sliding, cpset=INT-%d',k)};
    define_surf = cellstr(sprintf('left_surf-%d,right_surf-%d',k,k));
    interact_inp = [interact_inp; interact_head; define_surf];
end
interact_inp = ['**Interaction';interact_inp];
%% Insert new definitions into input file
%split input file into sections to insert new element sets
endassem_name = '*End Assembly';
output_name = '** OUTPUT REQUESTS';
step_name = '** STEP';
endass_loc = findNameLoc(C,endassem_name);
output_loc = findNameLoc(C,output_name);
step_loc = findNameLoc(C,step_name);
C1 = C(1:endass_loc-1);
C2 = C(endass_loc:step_loc-2);
C3 = C(step_loc:output_loc-1);
C4 = C(output_loc:end);
%recombine input
input_out = [C1;crack_inp;C2;surface_contact;C3;interact_inp;C4];
%output new inp file
filePh = fopen(output_file,'w');
fprintf(filePh, '%s\n',input_out{:});
fclose(filePh);