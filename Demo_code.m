
recognize=figure;
camera=figure;
if(exist('cam','var')==1)
    clear cam
end

realtime=false;
delay=0.2;
%detector_t=roadsign_net_aug_detector_2;
%detector_l=logo_rcnn_detector;


if(realtime)
    cam=webcam(1);
    a=0;
    while a==0
        
        a=waitforbuttonpress;
        img=snapshot(cam);
        figure(camera);
        imshow(img);
        
        %pause(delay);
        [bbox_t, score_t, label_t] = detect(roadsign_net_aug_detector_2, img);
        [bbox_l,score_l,label_l]=detect(logo_rcnn_detector,img);
        
        if(isempty(bbox_t)&&isempty(bbox_l))
            title('Unable to detect Text & Logo');
            %pause(delay);
            title('Image is out of Focus or too far');
        else
            if(isempty(bbox_l))
               detectedImg = insertObjectAnnotation(img, 'Rectangle', bbox_t,score_t);
                %cropp;
            else
                if(isempty(bbox_t))
                    detectedImg = insertObjectAnnotation(detectedImg, 'Rectangle',...
                        bbox_l,score_l);
                else
                    detectedImg = insertObjectAnnotation(img, 'Rectangle', bbox_t,score_t);
                    detectedImg = insertObjectAnnotation(detectedImg, 'Rectangle',...
                        bbox_l,score_l);
                    %cropp;
                end
            end
            imshow(detectedImg)
            cropp 
        
        end
    end
    
    clear cam;
else
    
    img=imread('test.jpg');
    img=imresize(img,[600,600]);
    [bbox_t, score_t, label_t] = detect(roadsign_net_aug_detector_2, img);
    [bbox_l,score_l,label_l]=detect(logo_rcnn_detector2,img);
    if(isempty(bbox_t)&&isempty(bbox_l))
        imshow(img)
        title('Unable to detect Text & Logo');
        %pause(delay);
        title('Image is out of Focus or too far');
    else
        if(~isempty(bbox_l) && ~isempty(bbox_t))
            detectedImg = insertObjectAnnotation(img, 'Rectangle', bbox_t,score_t);
            detectedImg = insertObjectAnnotation(detectedImg, 'Rectangle',...
                bbox_l,score_l);
            %cropp;
        else
            if(isempty(bbox_t))
                detectedImg = insertObjectAnnotation(detectedImg, 'Rectangle',...
                    bbox_l,score_l);
            else
                detectedImg = insertObjectAnnotation(img, 'Rectangle', bbox_t,score_t);
                %cropp;
            end
        end
    end
    %figure(camera);
    imshow(detectedImg)
    cropp;
    
    %     [bbox, score, label] = detect(detector_l, img);
    %     if(isempty(bbox))
    %         imshow(img)
    %         title('Unable to detect Logo');
    %     else
    %         detectedImg = insertObjectAnnotation(img, 'Rectangle', bbox,score);
    %         %detectedImg=insertText(detectedImg,bbox,string(label));
    %         imshow(detectedImg)
    %         cropp;
    %     end
end
