classdef coaOrInstruction < coaRInstruction
    
    methods
        
        function obj = coaOrInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '25';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end