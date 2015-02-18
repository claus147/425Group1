classdef coaSltInstruction < coaRInstruction
    
    methods
        
        function obj = coaSltInstruction(location,rs,rt,rd,label)
            
            shamt = '0';
            funct = '2a';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end