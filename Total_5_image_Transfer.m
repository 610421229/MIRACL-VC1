clc;clear;
load('Total_mouth_5_image');

    for user = 1 : 1500
        for image = 1 : 5
            total_5_image{user,image}=rgb2gray(total_5_image{user,image});
        end 
    end
    
total_5_image = total_5_image';
   
 total_5_image=reshape(total_5_image,1,7500);
 total_5_image=cell2mat(total_5_image);
 total_5_image=reshape(total_5_image,32,32,5,1500);
 
 for i = 1 : 15
     for j = 1 : 10
         for k = 1 : 10
            label((i-1)*100+(j-1)*10+k) = j;
         end
     end
 end
set(1:100) = 2;
 set(101:1500) = 1;
 

 mitdb.data=total_5_image;
 mitdb.label=label;
 mitdb.set=set;

