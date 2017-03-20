clear all;
tic;

%% Ū���C�H�ӧO��Ƨ�
for d = 9:9
    
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
            
            datadir = ['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\'] ;
            mkdir(['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\','face_ROI']);
            mkdir(['C:\Users\CTJeff\Desktop\MIRACL-VC1\' User_ID '\words\' Word_ID '\' times_10 '\','mouth_ROI']);
             input_dir = dir(fullfile(datadir, '*.jpg'));  % �N���w��Ƨ��������w���ɦW���Ҧ��ɮ׸�ơA��Jinput_dir�}�C
            [x, y ] = size(input_dir);
            %% �X�i�Ϥ��N�]�X��
            for n = 1 : x
                pic = num2str(n); times = num2str(times); word = num2str(word); %���F�L�X�Ӥ����n
                [User_ID,' ',word,' ',times,' ',pic]
                
                img = imread(fullfile(datadir, input_dir(n).name));
                 faceDetector =vision.CascadeObjectDetector;  % �H�y���Ѿ�
                fboxes = step(faceDetector, img);  % ��X�H�y
                %  fboxes[a,b,c,d]: a->���W����x�y�� b->���W����y�y�� c->�y���ϰ쪺�e d->�y���ϰ쪺��
                faceROI = insertObjectAnnotation(img, 'rectangle', fboxes, 'Face');
                [fboxesx, fboxesy] = size(fboxes);
                farea = 0; % �y�����n�Ѽ�
                maxarea = 0; % �̤j�y�����n�Ѽ�
            
                if fboxesx == 0 % �䤣��H�y�N���ʧ@�A�ҥH�|�ϥΫe�@�i�ŤU�Ӫ��ϰ�M�Υثe�o�i
                
                elseif fboxesx == 1 % ��X�y���ϰ쪺�I��e��
                    
                    left = fboxes(1);  % ���W���� x �y��
                    top = fboxes(2) - 10;   % ���W���� y �y�� -10:�Ȥ����U�L�B����
                    width = fboxes(3);  % �ϰ쪺�e
                    height = fboxes(4) + 30;  % �ϰ쪺�� +30:�Ȥ����U�L�B����
                    
                else % ��줣�u�@�i�y�ɡA���y�����n�̤j��
                    
                    for i = fboxesx*2+1 : fboxesx*3 % �q�Ĥ@�Ӫ��e�����}�l
                        
                            farea = fboxes(i)*fboxes(i + fboxesx); % ���n=�e*��
                        
                            if farea > maxarea % �ثe�y���ϰ�j��̤j�y���ϰ�A�N���N�íק�y�лP�̤j���n��
                            
                            maxarea = farea;
                            % ���y���ϰ쪺�y���I��e��
                            left = fboxes(i - 2*fboxesx);
                            top = fboxes(i - fboxesx) - 10;
                            width = fboxes(i);
                            height = fboxes(i + fboxesx) ;
                            
                            end
                    end
                end
            %faceROI = imcrop(img, [left top+height/2 width height/3]);% �N�H�y�ϰ�ŤU
            faceROI = imcrop(img, [left top width height]);% �N�H�y�ϰ�ŤU
            [Height,Width,Depth] = size(faceROI);
            imwrite(faceROI,[datadir 'face_ROI\' input_dir(n).name]);  % �N�y���ϰ�s���ɮ�
            %% ��L��
            mouthDetector = vision.CascadeObjectDetector('Mouth');  % �L�B���Ѿ�
            mboxes = step(mouthDetector, faceROI);  % ��X�L�B
            lipROI = insertObjectAnnotation(faceROI, 'rectangle', mboxes, 'Mouth');
            [mboxesx, mboxesy] = size(mboxes);
            maxtop = 0; % ��̤j��Y
            re = 0;   % �P�_�O�_����ϰ쥢�Ѫ��Ѽ�
        
            if mboxesx ==0 
                lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % �ŤU�̫᪺�L�ڰϰ�
                %fprintf(fid,'%s\n',input_dir(n).name);
                %continue; % ���U�@�i��
            
            elseif mboxesx == 1
                if  mboxes(2) < Height/3
                        lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);
                else
                mouthleft = mboxes(1);
                mouthtop = mboxes(2)-5;
                mouthwidth = mboxes(3);
                mouthheight = mboxes(4);
                re = 1; % �N�������\
                lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % �ŤU�̫᪺�L�ڰϰ�
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
                        lipROI = imcrop(faceROI, [mouthleft mouthtop mouthwidth mouthheight]);   % �ŤU�̫᪺�L�ڰϰ�
                    end
            end

            mouthroi = [mouthleft mouthtop mouthwidth mouthheight];
            lipROI = imresize(lipROI,[32 32]);
            imwrite(lipROI,[datadir 'mouth_ROI\' input_dir(n).name]);  % �N�L�ڰϰ�s���ɮ�
            end
        end
    end
end
toc;