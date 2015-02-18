classdef coaSubInstruction < coaRInstruction
    
    methods
        
        function obj = coaSubInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '22';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end