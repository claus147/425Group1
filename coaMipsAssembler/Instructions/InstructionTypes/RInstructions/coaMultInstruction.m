classdef coaMultInstruction < coaRInstruction
    
    methods
        
        function obj = coaMultInstruction(location,rs,rt,label)
            
            rd = '$0';
            shamt = '0';
            funct = '18';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end