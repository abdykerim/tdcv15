function B = unpadarray(A, Bsize)
Bstart = ceil((size(A)-Bsize)/2)+1;
Bend = Bstart+Bsize-1;
B = A(Bstart(1):Bend(1),Bstart(2):Bend(2));
end