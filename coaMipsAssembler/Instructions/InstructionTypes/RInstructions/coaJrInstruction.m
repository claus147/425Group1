classdef coaJrInstruction < coaRInstruction
    
    methods
        
        function obj = coaJrInstruction(location,rs,label)
            
            rt = '0';
            rd = '0';
            shamt = '0';
            funct = '8';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end