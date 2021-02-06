function GidPostProcess(COOR,CN,TypeElement,d,qheatGLO,NAME_INPUT_DATA,posgp,NameFileMesh); 
% Post-process of nodal temperatures (d) and flux vector (qheatGLO) using
% GID 
 ndim = size(COOR,2); 

if  ndim == 2 
    GidPostProcess2D(COOR,CN,TypeElement,d,qheatGLO,NAME_INPUT_DATA,posgp,NameFileMesh); 
elseif ndim ==3
    error('Option not implemented yet')
end

 