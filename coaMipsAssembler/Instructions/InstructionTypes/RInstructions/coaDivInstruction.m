classdef coaDivInstruction < coaRInstruction
    
    methods
        
        function obj = coaDivInstruction(location,rs,rt,label)
            
            rd = '0';
            shamt = '0';
            funct = '1a';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end