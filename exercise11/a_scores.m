close all;
%Pyramid scheme assuming the picture is bigger than the template, not other
%way around
scale_size = 5;
% Image
I_color = cell(1,scale_size+1);
% I_gray = cell(1,scale_size+1);
I_color{1} = im2double(imread('img.jpg'));
% I_gray{1} = rgb2gray(I_color{1});
% Template
T_color = im2double(imread('template2.jpg'));
T_gray = rgb2gray(T_color);

img_SSD_color = cell(1,scale_size);
img_NCC_color = cell(1,scale_size);
% img_SSD_gray = cell(1,scale_size);
% img_NCC_gray = cell(1,scale_size);
max_SSD_color = 0;
% max_SSD_gray = 0;
max_NCC_color = 0;
% max_NCC_gray = 0;
best_scale_ssd_color = 0;
% best_scale_ssd_gray = 0;
best_scale_ncc_color = 0;
% best_scale_ncc_gray = 0;
for scale = 1:scale_size
    
    % RGB COLOR
%     Calculate SSD and NCC between Template and Image in RGB
    tic;
    [img_SSD_color{scale},img_NCC_color{scale}]=ssd_ncc(T_color,I_color{scale});
    toc
    if max_SSD_color <= max(img_SSD_color{scale}(:))
%         Find maximum correspondence in SDD image
        [x,y]=find(img_SSD_color{scale}==max(img_SSD_color{scale}(:)));
        max_SSD_color = max(img_SSD_color{scale}(:));
        best_scale_ssd_color = scale;
    end
    
    if max_NCC_color <= max(img_NCC_color{scale}(:))
%         Find maximum correspondence in NCC image
        [x2,y2]=find(img_NCC_color{scale}==max(img_NCC_color{scale}(:)));
        max_NCC_color = max(img_NCC_color{scale}(:));
        best_scale_ncc_color = scale;
    end
    
    % GRAYSCALE
    % Calculate SSD and NCC between Template and Image in grayscale
%     tic;
%     [img_SSD_gray,img_NCC_gray]=ssd_ncc(T_gray,rgb2gray(I_color));
%     toc
%     if max_SSD_gray <= max(img_SSD_gray{scale}(:))
        % Find maximum correspondence in SDD image
%         [x3,y3]=find(img_SSD_gray==max(img_SSD_gray(:)));
%         max_SSD_gray = max(img_SSD_gray{scale}(:));
%         best_scale_ssd_gray = scale;
%     end
    
%     if max_NCC_gray <= max(img_NCC_gray{scale}(:))
        % Find maximum correspondence in NCC image
%         [x4,y4]=find(img_NCC_gray==max(img_NCC_gray(:)));
%         max_NCC_gray = max(img_NCC_gray{scale}(:));
%         best_scale_ncc_gray = scale;
%     end
    
    %scale down the picture
    I_color{scale+1} = imresize(I_color{scale}, 0.8);
%     I_gray{scale+1} = rgb2gray(I_color{scale+1});
end

best_scale_ncc_color
% RGB COLOR
% Show result
figure,
subplot(2,2,1), imshow(I_color{best_scale_ncc_color}); hold on; plot(y2,x2,'b*'); title('Result')
subplot(2,2,2), imshow(T_color); title('The template');
subplot(2,2,3), imshow(img_SSD_color{best_scale_ncc_color}); title('SSD');
subplot(2,2,4), imshow(img_NCC_color{best_scale_ncc_color}); title('NCC');

% best_scale_ssd_gray
% GRAYSCALE
% Show result
% figure,
% subplot(2,2,1), imshow(rgb2gray(I_color)); hold on; plot(y3,x3,'r*'); title('Result')
% subplot(2,2,2), imshow(T_gray); title('The template');
% subplot(2,2,3), imshow(img_SSD_gray); title('SSD');
% subplot(2,2,4), imshow(img_NCC_gray); title('NCC');