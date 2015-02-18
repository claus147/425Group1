classdef coaSraInstruction < coaRInstruction
    
    methods
        
        function obj = coaSraInstruction(location,rt,rd,shamt,label)
            
            rs = '$0';
            funct = '3';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end