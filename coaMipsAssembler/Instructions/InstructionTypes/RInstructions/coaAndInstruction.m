classdef coaAndInstruction < coaRInstruction
    
    methods
        
        function obj = coaAndInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '24';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end