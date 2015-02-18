classdef coaSrlInstruction < coaRInstruction
    
    methods
        
        function obj = coaSrlInstruction(location,rt,rd,shamt,label)
            
            rs = '$0';
            funct = '2';
            
            obj@coaRInstruction(location,rs,rt,rd,shamt,funct,label);
            
        end
        
    end
    
end