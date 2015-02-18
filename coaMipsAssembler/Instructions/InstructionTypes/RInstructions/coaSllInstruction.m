classdef coaSllInstruction < coaRInstruction
    
    methods
        
        function obj = coaSllInstruction(location,rt,rd,shamt,label)
            
            rs = '$0';
            funct = '0';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end