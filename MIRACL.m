clear all;
tic;

%% 讀取每人個別資料夾
for d = 9:9
    
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
            
            datadir = ['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\'] ;
            mkdir(['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\','face_ROI']);
            mkdir(['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\','mouth_ROI']);
             input_dir = dir(fullfile(datadir, '*.jpg'));  % 將指定資料夾內的指定副檔名的所有檔案資料，丟入input_dir陣列
            [x, y ] = size(input_dir);
            %% 幾張圖片就跑幾次
            for n = 1 : x
                pic = num2str(n); times = num2str(times); word = num2str(word); %為了印出來不重要
                [User_ID,' ',word,' ',times,' ',pic]
                
                img = imread(fullfile(datadir, input_dir(n).name));
                 faceDetector =vision.CascadeObjectDetector;  % 人臉辨識器
                fboxes = step(faceDetector, img);  % 找出人臉
                %  fboxes[a,b,c,d]: a->左上角的x座標 b->左上角的y座標 c->臉部區域的寬 d->臉部區域的高
                faceROI = insertObjectAnnotation(img, 'rectangle', fboxes, 'Face');
                [fboxesx, fboxesy] = size(fboxes);
                farea = 0; % 臉部面積參數
                maxarea = 0; % 最大臉部面積參數
            
                if fboxesx == 0 % 找不到人臉就不動作，所以會使用前一張剪下來的區域套用目前這張
                
                elseif fboxesx == 1 % 抓出臉部區域的點跟寬高
                    
                    left = fboxes(1);  % 左上角的 x 座標
                    top = fboxes(2) - 10;   % 左上角的 y 座標 -10:怕切掉下嘴唇部分
                    width = fboxes(3);  % 區域的寬
                    height = fboxes(4) + 30;  % 區域的高 +30:怕切掉下嘴唇部分
                    
                else % 找到不只一張臉時，取臉部面積最大的
                    
                    for i = fboxesx*2+1 : fboxesx*3 % 從第一個的寬的欄位開始
                        
                            farea = fboxes(i)*fboxes(i + fboxesx); % 面積=寬*高
                        
                            if farea > maxarea % 目前臉部區域大於最大臉部區域，就取代並修改座標與最大面積值
                            
                            maxarea = farea;
                            % 取臉部區域的座標點跟寬高
                            left = fboxes(i - 2*fboxesx);
                            top = fboxes(i - fboxesx) - 10;
                            width = fboxes(i);
                            height = fboxes(i + fboxesx) ;
                            
                            end
                    end
                end
            %faceROI = imcrop(img, [left top+height/2 width height/3]);% 將人臉區域剪下
            faceROI = imcrop(img, [left top width height]);% 將人臉區域剪下
            [Height,Width,Depth] = size(faceROI);
            imwrite(faceROI,[datadir 'face_ROI\' input_dir(n).name]);  % 將臉部區域存成檔案
            %% 找嘴巴
            mouthDetector = vision.CascadeObjectDetector('Mouth');  % 嘴唇辨識器
            mboxes = step(mouthDetector, faceROI);  % 找出嘴唇
            lipROI = insertObjectAnnotation(faceROI, 'rectangle', mboxes, 'Mouth');
            [mboxesx, mboxesy] = size(mboxes);
            maxtop = 0; % 找最大的Y
            re = 0;   % 判斷是否抓取區域失敗的參數
        
            if mboxesx ==0 
                lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % 剪下最後的嘴巴區域
                %fprintf(fid,'%s\n',input_dir(n).name);
                %continue; % 跳下一張圖
            
            elseif mboxesx == 1
                if  mboxes(2) < Height/3
                        lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);
                else
                mouthleft = mboxes(1);
                mouthtop = mboxes(2)-5;
                mouthwidth = mboxes(3);
                mouthheight = mboxes(4);
                re = 1; % 代表抓取成功
                lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % 剪下最後的嘴巴區域
                end
            else
                    [x y] = max(mboxes(:,2));
                    if  x < Height/3
                        lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);
                    else
                        mouthleft = mboxes(y,1);
                        mouthtop = mboxes(y,2)-5;
                        mouthwidth = mboxes(y,3);
                        mouthheight = mboxes(y,4) ;
                        lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % 剪下最後的嘴巴區域
                    end
            end

            mouthroi = [mouthleft mouthtop mouthwidth mouthheight];
            lipROI = imresize(lipROI,[32 32]);
            imwrite(lipROI,[datadir 'mouth_ROI\' input_dir(n).name]);  % 將嘴巴區域存成檔案
            end
        end
    end
end
toc;