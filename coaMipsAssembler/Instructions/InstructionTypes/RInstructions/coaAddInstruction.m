classdef coaAddInstruction < coaRInstruction
    
    methods
        
        function obj = coaAddInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '20';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end