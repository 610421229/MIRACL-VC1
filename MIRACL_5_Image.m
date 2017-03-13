clear all;
tic;
total_5_face = [];
%% 讀取每人個別資料夾
for d = 1:15 
    
    User_ID = num2str(d);
    
    %% 讀取Word ID(指令)
    for word = 1:10 
     
        if word < 10
            word = num2str(word); 
            Word_ID = ['0' word];
        else
            Word_ID = num2str(word);
        end
        %% 讀取相同Word_ID圖片資料夾
        for times = 1:10 
          
            if times < 10
                times = num2str(times);
                times_10 = ['0' times];
            else
                times_10 = num2str(times);
            end
            
            datadir = ['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\','mouth_ROI'] ;
            mkdir(['C:\Users\CTJeff\Desktop\MIRACL-VC1\Mouth_5_Image\' User_ID '\words\' Word_ID '\' times_10 ]);
            datadir_5 = ['C:\Users\CTJeff\Desktop\MIRACL-VC1\Mouth_5_Image\' User_ID '\words\' Word_ID '\' times_10 '\',];
             input_dir = dir(fullfile(datadir, '*.jpg'));  % 將指定資料夾內的指定副檔名的所有檔案資料，丟入input_dir陣列
            [x, y ] = size(input_dir);
            avarage = x/5;
            %% 取五張圖片
            
            if ischar(word)
                 word = str2num(word);
            end
            
            if ischar(times)
                 times = str2num(times);
            end
            
            for n = 1 : 5
               avarage_count = round(avarage * n);
                faceCatch5 = imread(fullfile(datadir, input_dir(avarage_count).name));
                faceCatch5 = imresize(faceCatch5,[32 32]);
                imwrite(faceCatch5,[datadir_5 input_dir(n).name]);
                total_5_image{(d-1)*100+(word-1)*10+times,n} = faceCatch5;
            end
        end
    end
end
toc;