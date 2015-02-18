classdef coaNorInstruction < coaRInstruction
    
    methods
        
        function obj = coaNorInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '27';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end