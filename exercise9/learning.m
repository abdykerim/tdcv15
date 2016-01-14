for i = 1:1
    imname = ['seq\im' sprintf('%03d',i-1) '.pgm'];
    img = imread(imname);
%     figure(1), imshow(img);    
    
%      outname = ['out\im' sprintf('%03d',i-1) '.pgm'];
%     img2 = imread(outname);
%      figure(2), imshow(img2);  
%     i
end

% figure, imshow(img);
% hold on;
% plot(180,230,'r.','MarkerSize',20); 
% plot(280,230,'r.','MarkerSize',20); 
% plot(180,330,'r.','MarkerSize',20); 
% plot(280,330,'r.','MarkerSize',20);
t_coords = [180, 230; 280, 230; 180, 330; 280, 330];
A = cell (1,10);
for i = 1:10
    A{i} = computeA(img, t_coords, i);
end