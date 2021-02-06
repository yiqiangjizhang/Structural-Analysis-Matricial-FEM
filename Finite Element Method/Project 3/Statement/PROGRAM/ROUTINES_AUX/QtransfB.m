function Be = QtransfB(BeTILDE,ndim)
%
if nargin == 0
    load('tmp2.mat')
end


nnodeE = size(BeTILDE,2); 
if ndim==2 
   nstrain = 3 ;    Be = zeros(nstrain,nnodeE*ndim) ; 
   column1 = 1:2:(nnodeE*2-1) ;
   column2 = 2:2:nnodeE*2 ;
   Be(1,column1) = BeTILDE(1,:) ; 
   Be(2,column2) = BeTILDE(2,:) ; 
   Be(3,column1) = BeTILDE(2,:) ; 
   Be(3,column2) = BeTILDE(1,:) ; 
elseif ndim ==3 
   
   
   error('This part of the function is missing...Implement it')
   
else
   error('Incorrect option')
end