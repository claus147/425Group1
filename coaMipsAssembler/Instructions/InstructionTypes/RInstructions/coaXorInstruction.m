classdef coaXorInstruction < coaRInstruction
    
    methods
        
        function obj = coaXorInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '26';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end