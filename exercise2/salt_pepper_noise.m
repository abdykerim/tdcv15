function out = salt_pepper_noise(im, p3)
    
      out = im;  % <-- Assign out to the input image
      x = rand(size(im)); %<--- Generate random pixels from the image pixels
      d = find(x < p3/2); %<--- Find the pixels whose values are less than half of the mean value  
      out(d) = 0; %<-- Implement minimum saturation to them
      d = find(x >= p3/2 & x < p3); %<--- Find the pixels whose values are greater than half of the mean value & less than mean value
      out(d) = 1;    % <-- Implement maximum saturation to them 
end
