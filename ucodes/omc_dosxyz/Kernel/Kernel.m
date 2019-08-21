clc; clear all;
tic;
data_dose = zeros(61,1620);
data_udose = zeros(61,1620);
e_1 = 1;
e_2 = 61;

fi = fopen('kernel_file.txt','w');
num_energies = 61;
fprintf(fi,'%d \n',num_energies);
fprintf(fi,'\n');

Energy = 0.1*(0:60);
fprintf(fi,'%2.1f ',Energy);
fprintf(fi,'\n');

for E = e_1:e_2
    
    a = (E-1)*0.1;
    
    fname = sprintf('kernel_h2o_%2.1fMeV',a);
    fid = strcat(fname,'.txt');
    fp = fopen(fid);
   
    % # of voxels in x,y,z direction
    NumLines = 3;
    block1 = textscan(fp,'%d %d %d', NumLines);
    num_vox_x = double(block1{1,1});
    num_vox_y = double(block1{1,2});
    num_vox_z = double(block1{1,3});
    tot_vox = num_vox_x*num_vox_y*num_vox_z;
    block2 = textscan(fp,'%s %s');
    d_dose = block2{1,1};
    d_udose = block2{1,2};
    
    % Write kernel size to file only one time
    if E == e_1
        fprintf(fi,'\n');
        fprintf(fi,'%d %d %d \t',num_vox_x,num_vox_y,num_vox_z);
        fprintf(fi,'\n');
    end
    
    %Eliminaci???n de la primera fila ya que no son datos num???ricos
    d_dose(1,:)=[];
    d_udose(1,:)=[];  
    
    % Transformacion d_dose y d_udose a double y suma de los elementos
    d_dose = str2double(d_dose);
    d_udose = str2double(d_udose);
    S = sum(d_dose);
    
    %Normalizacion
    if S > 0.0 
    d_dose(:) = d_dose(:)/S; 
    end
    
    % Definici???n de kernels en funci???n de la energ???a y posici???n 
    for idx = 1:tot_vox               
        data_dose(E,idx) = d_dose(idx);
%        data_udose(E,idx) = str2double(d_udose(idx));
        fprintf(fi,'\n');
        fprintf(fi, '%e ', data_dose(E,idx));
    end
    
    fprintf(fi,'\n');
        
    fclose(fp);
    
end 
   
fclose(fi);
   
time = toc;