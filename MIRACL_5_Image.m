clear all;
tic;
total_5_face = [];
%% Ū���C�H�ӧO��Ƨ�
for d = 1:15 
    
    User_ID = num2str(d);
    
    %% Ū��Word ID(���O)
    for word = 1:10 
     
        if word < 10
            word = num2str(word); 
            Word_ID = ['0' word];
        else
            Word_ID = num2str(word);
        end
        %% Ū���ۦPWord_ID�Ϥ���Ƨ�
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
             input_dir = dir(fullfile(datadir, '*.jpg'));  % �N���w��Ƨ��������w���ɦW���Ҧ��ɮ׸�ơA��Jinput_dir�}�C
            [x, y ] = size(input_dir);
            avarage = x/5;
            %% �����i�Ϥ�
            
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