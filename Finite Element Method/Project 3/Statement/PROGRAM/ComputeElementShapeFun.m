function [weig,posgp,shapef,dershapef] = ComputeElementShapeFun(TypeElement,nnodeE,TypeIntegrand) ;
% This function returns, for each "TypeElement" and 'TypeIntegrand'
% (K/RHS)*
% weig = Vector of Gauss weights (1xngaus)
% posgp: Position of Gauss points  (ndim x ngaus)
% shapef: Array of shape functions (ngaus x nnodeE)
% dershape: Array with the derivatives of shape functions, with respect to
% element coordinates (ndim x nnodeE x ngaus)
%
% *) TypeIntegrand = 'K': For integration of Conductance Matrix
% *) TypeIntegrand = 'RHS': For integration of flux vectors
%dbstop('13')
if nargin == 0
    load('tmp.mat')
end

switch TypeElement
    case 'Linear'
        if nnodeE ==2
            [weig,posgp,shapef,dershapef] = Linear2NInPoints(TypeIntegrand) ;
        else
            error('Option not implemented')
        end
    case 'Quadrilateral'
        if nnodeE ==4
           error('Implement function Quadrilateral4NInPoints  (you can use the one developed for heat conduction problems)')
           %     [weig,posgp,shapef,dershapef] = Quadrilateral4NInPoints ;
        else
            warning('Option not implemented')
        end
    case 'Hexahedra'
        
        error('Implement function Hexahedra8NInPoints')
        %    [weig,posgp,shapef,dershapef] = Hexahedra8NInPoints ;
        [weig,posgp,shapef,dershapef] = Hexahedra8NInPoints ;
    otherwise
        error('Option not implemented')
end